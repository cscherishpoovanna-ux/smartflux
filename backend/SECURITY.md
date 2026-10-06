# SmartFlux backend security boundary

- No user login UI is used by the mobile application.
- Production API deployment must be behind HTTPS/TLS; certificate validation must never be disabled.
- Device/service authorization is separate from user authentication. Use a registered device identity or service credential at the gateway; never put an admin secret in Flutter.
- Relay control accepts abstract `load_id` and `state`, never raw GPIO values.
- Validate telemetry and commands on the server before storage or execution.
- MQTT publishing should happen only in the backend/device gateway using TLS and restricted topics.
- Use a parameterized ORM/database layer when replacing the in-memory store.
- Apply rate limiting at the edge/gateway for production deployments and use a shared store when multiple backend instances run.
- Audit control actions with command IDs and outcomes. Distinguish accepted/sent/acknowledged/executed/failed/timeout states.
- Keep production secrets in environment/secret-management infrastructure, never source control or mobile assets.
- Demo mode must remain disconnected from physical devices.
