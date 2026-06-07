#!/usr/bin/env python3
"""
Smoke tests — run post-deploy against the live app URL.
Usage: python smoke_test.py https://<your-app-url>
"""
import sys
import requests
import time

def smoke_test(base_url: str, retries: int = 10, delay: int = 6):
    print(f"Running smoke tests against: {base_url}")
    failures = []

    def get_with_retry(path, expected_status=200):
        url = f"{base_url}{path}"
        for attempt in range(1, retries + 1):
            try:
                resp = requests.get(url, timeout=5)
                if resp.status_code == expected_status:
                    print(f"  ✓ {path} returned {resp.status_code}")
                    return resp
                else:
                    print(f"  ✗ {path} returned {resp.status_code} (attempt {attempt}/{retries})")
            except requests.exceptions.ConnectionError as e:
                print(f"  ✗ {path} connection failed (attempt {attempt}/{retries}): {e}")
            if attempt < retries:
                time.sleep(delay)
        return None

    # Test 1 — root endpoint
    resp = get_with_retry("/")
    if resp is None:
        failures.append("GET / failed after retries")
    else:
        data = resp.json()
        if data.get("status") != "ok":
            failures.append(f"GET / body unexpected: {data}")

    # Test 2 — health endpoint
    resp = get_with_retry("/health")
    if resp is None:
        failures.append("GET /health failed after retries")

    # Test 3 — readiness endpoint
    resp = get_with_retry("/ready")
    if resp is None:
        failures.append("GET /ready failed after retries")

    # Test 4 — tax calculation
    try:
        url = f"{base_url}/calculate-tax"
        resp = requests.post(url, json={"salary": 50000}, timeout=5)
        if resp.status_code == 200:
            print(f"  ✓ POST /calculate-tax returned 200")
        else:
            failures.append(f"POST /calculate-tax returned {resp.status_code}")
    except requests.exceptions.ConnectionError as e:
        failures.append(f"POST /calculate-tax connection failed: {e}")

    # Report
    print()
    if failures:
        print("SMOKE TESTS FAILED:")
        for f in failures:
            print(f"  - {f}")
        sys.exit(1)
    else:
        print("All smoke tests passed ✓")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python smoke_test.py <base_url>")
        sys.exit(1)
    smoke_test(sys.argv[1])