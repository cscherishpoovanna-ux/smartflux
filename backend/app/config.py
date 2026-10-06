import os

class Config:
    HIGH_DEMAND_W = float(os.getenv('SMARTFLUX_HIGH_DEMAND_W', '1800'))
    OVERLOAD_W = float(os.getenv('SMARTFLUX_OVERLOAD_W', '2400'))
    RATE_LIMIT = int(os.getenv('SMARTFLUX_RATE_LIMIT', '30'))
    RATE_WINDOW_SECONDS = int(os.getenv('SMARTFLUX_RATE_WINDOW_SECONDS', '60'))
    REQUIRE_DEVICE_ID = os.getenv('SMARTFLUX_REQUIRE_DEVICE_ID', 'false').lower() == 'true'
    ALLOWED_DEVICES = {x.strip() for x in os.getenv('SMARTFLUX_ALLOWED_DEVICES', 'demo-device').split(',') if x.strip()}
