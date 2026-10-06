from dataclasses import dataclass
from datetime import datetime
from typing import Any

MAX_ID_LEN = 80
VALID_STATES = {'on', 'off'}

class ValidationError(ValueError):
    pass

def safe_id(value: Any, field: str) -> str:
    if not isinstance(value, str) or not value or len(value) > MAX_ID_LEN or not value.replace('-', '').replace('_', '').isalnum():
        raise ValidationError(f'invalid {field}')
    return value

def control_payload(data: Any) -> dict[str, str]:
    if not isinstance(data, dict) or set(data.keys()) - {'state'} or data.get('state') not in VALID_STATES:
        raise ValidationError('invalid control payload')
    return {'state': data['state']}

def telemetry_payload(data: Any) -> dict[str, Any]:
    if not isinstance(data, dict): raise ValidationError('invalid telemetry payload')
    required = {'device_id','room_id','voltage_v','current_a','power_w','energy_kwh','timestamp'}
    if set(data) - required or not required.issubset(data): raise ValidationError('invalid telemetry fields')
    device_id, room_id = safe_id(data['device_id'], 'device_id'), safe_id(data['room_id'], 'room_id')
    numbers = {'voltage_v': (0.0, 300.0), 'current_a': (0.0, 100.0), 'power_w': (0.0, 20000.0), 'energy_kwh': (0.0, 1000000.0)}
    out = {'device_id': device_id, 'room_id': room_id}
    for key, (low, high) in numbers.items():
        value = data[key]
        if isinstance(value, bool) or not isinstance(value, (int, float)) or not low <= value <= high: raise ValidationError(f'invalid {key}')
        out[key] = float(value)
    try: datetime.fromisoformat(str(data['timestamp']).replace('Z', '+00:00'))
    except ValueError as exc: raise ValidationError('invalid timestamp') from exc
    out['timestamp'] = str(data['timestamp'])
    return out
