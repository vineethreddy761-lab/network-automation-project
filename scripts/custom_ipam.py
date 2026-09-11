#!/usr/bin/env python3
import json
import sys

def main():
    try:
        # Read all stdin lines if present
        input_data = json.load(sys.stdin)
    except Exception:
        input_data = {}

    env = input_data.get("environment", "lab")

    # Generate mock dynamic networking configurations
    if env == "lab":
        output = {
            "local_asn": "65001",
            "remote_asn": "65002",
            "tunnel_subnet": "10.255.255.0/30",
            "status": "active"
        }
    else:
        output = {
            "local_asn": "65001",
            "remote_asn": "65999",
            "tunnel_subnet": "10.255.255.4/30",
            "status": "error"
        }

    print(json.dumps(output))

if __name__ == "__main__":
    main()
