# IoT SmartFlux

Production-oriented Flutter client for an IoT energy monitoring and grid optimization system.

## Architecture

`ESP32 -> MQTT/TLS -> Flask API/control gateway -> database/Firebase -> Flutter`

The Flutter UI depends on `EnergyRepository`, not on hardware or MQTT. `DemoEnergyRepository` is the default safe development mode. `ApiEnergyRepository` is ready for a real backend.

## Prototype hardware reference

- ESP32
- ZMPT101B: GPIO32/33/34/35 for Rooms 1-4
- ACS712: GPIO25/26/27/14 for Rooms 1-4
- Relay: GPIO12/13/15/2 for Rooms 1-4
- I2C LCD: SDA21/SCL22 (hardware-only)
- Room 4 remains Reserved / Not Connected.

## Run

Install Flutter 3.47.x or newer, then:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

For a real backend, set `ApiEnergyRepository(baseUrl: 'https://your-host')` in the composition root. Do not embed backend admin credentials in the app.

## Branding assets

Place the official supplied logo under `assets/branding/smartflux_logo.png` and the official reveal video under `assets/video/smartflux_reveal.mp4`. The startup screen has a safe animated-logo fallback if the video is unavailable.

## Security

The app has no login/authentication UI. Production authorization belongs at the backend/device-service boundary. Relay commands use abstract load IDs, never arbitrary GPIO numbers. Demo mode cannot reach physical devices.
