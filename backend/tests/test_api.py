import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1]))
from app.main import create_app


def client():
    app = create_app(); app.testing = True; return app.test_client()

def test_unknown_relay_is_rejected():
    c = client(); r = c.post('/api/loads/load-led-2/control', json={'state':'off'}); assert r.status_code == 409

def test_invalid_payload_is_rejected():
    c = client(); r = c.post('/api/loads/load-motor-1/control', json={'state':'gpio15'}); assert r.status_code == 400

def test_unknown_device_telemetry_rejected():
    c = client(); r = c.post('/api/telemetry', json={'device_id':'unknown','room_id':'room-1','voltage_v':230,'current_a':1,'power_w':230,'energy_kwh':1,'timestamp':'2026-10-02T10:00:00+00:00'}); assert r.status_code == 403

def test_malformed_sensor_value_rejected():
    c = client(); r = c.post('/api/telemetry', json={'device_id':'demo-device','room_id':'room-1','voltage_v':9999,'current_a':1,'power_w':230,'energy_kwh':1,'timestamp':'2026-10-02T10:00:00+00:00'}); assert r.status_code == 400
