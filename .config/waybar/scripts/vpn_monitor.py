#!/usr/bin/env python3
import subprocess
import sys
import select

def update_status():
    try:
        result = subprocess.run(['vpn'], capture_output=True, text=True, check=True)
        sys.stdout.write(result.stdout)
        sys.stdout.flush()
    except subprocess.CalledProcessError:
        sys.exit(1)

def main():
    # Initial state
    update_status()
    
    # Monitor NetworkManager events
    with subprocess.Popen(
        ['nmcli', 'monitor'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    ) as nmcli:
        poll = select.poll()
        poll.register(nmcli.stdout.fileno(), select.POLLIN)
        
        try:
            while True:
                if poll.poll(1000):  # 1 second timeout
                    line = nmcli.stdout.readline()
                    if not line:
                        break
                    if any(x in line.lower() for x in ['vpn', 'wireguard', 'connection']):
                        update_status()
        except KeyboardInterrupt:
            sys.exit(0)

if __name__ == "__main__":
    main()
