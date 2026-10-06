from flask import Blueprint, jsonify, request
from .config import Config
from .rate_limit import RateLimiter
from .store import Store
from .validation import ValidationError, control_payload, safe_id, telemetry_payload

bp = Blueprint('api', __name__, url_prefix='/api')
store = Store()
limiter = RateLimiter(Config.RATE_LIMIT, Config.RATE_WINDOW_SECONDS)

def reject(message, code=400): return jsonify({'error': message}), code

def device_allowed():
    if not Config.REQUIRE_DEVICE_ID: return True
    device = request.headers.get('X-Device-Id', '')
    return device in Config.ALLOWED_DEVICES

@bp.before_request
def guard():
    if not limiter.allow(request.remote_addr or 'unknown'): return reject('Too many requests.', 429)
    if request.method in {'POST','PUT','PATCH','DELETE'} and not device_allowed(): return reject('Request not authorized.', 403)

@bp.get('/system/status')
def status(): return jsonify({'mode':'backend','status':'normal','high_demand_w':Config.HIGH_DEMAND_W,'overload_w':Config.OVERLOAD_W})

@bp.get('/rooms')
def rooms(): return jsonify(store.rooms)

@bp.get('/loads')
def loads(): return jsonify([l.__dict__ for l in store.loads.values()])

@bp.post('/telemetry')
def telemetry():
    try: payload = telemetry_payload(request.get_json(silent=True))
    except ValidationError as exc: return reject(str(exc), 400)
    if payload['device_id'] not in Config.ALLOWED_DEVICES: return reject('Unknown device.', 403)
    store.telemetry.append(payload)
    return jsonify({'status':'accepted'}), 202

@bp.post('/loads/<load_id>/control')
def control(load_id):
    try: load_id = safe_id(load_id, 'load_id'); body = control_payload(request.get_json(silent=True))
    except ValidationError as exc: return reject(str(exc), 400)
    command_id = store.control(load_id, body['state'])
    if command_id is None: return reject('Load is unknown or not controllable.', 409)
    # Production deployment must publish this abstract command to the device gateway/MQTT over TLS.
    return jsonify({'status':'acknowledged','command_id':command_id,'state':body['state']}), 202

@bp.get('/audit')
def audit(): return jsonify(store.audit[-100:])
