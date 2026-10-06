import time
from collections import defaultdict, deque
from threading import Lock

class RateLimiter:
    def __init__(self, limit: int, window: int):
        self.limit, self.window = limit, window
        self._hits = defaultdict(deque)
        self._lock = Lock()
    def allow(self, key: str) -> bool:
        now = time.monotonic()
        with self._lock:
            q = self._hits[key]
            while q and now - q[0] >= self.window: q.popleft()
            if len(q) >= self.limit: return False
            q.append(now)
            return True
