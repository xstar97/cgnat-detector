#!/bin/bash

# Get your public IP address using curl
public_ip=$(curl -s ifconfig.me)

# Check if public_ip is empty
if [ -z "$public_ip" ]; then
    echo "Unable to determine your public IP address."
else
    echo "Public IP: $public_ip"

    # Perform a traceroute to your public IP address
    hop_count=$(traceroute -n $public_ip | tail -n 1 | awk '{print $1}')
    
    if [ -n "$hop_count" ]; then
        echo "Hops: $hop_count"
        
        # Check if CGNAT is detected
        if [ "$hop_count" -gt 2 ]; then
            echo "CGNAT Alert: CGNAT detected. Please review your network configuration."
        else
            echo "CGNAT status: Clear! No CGNAT detected."
        fi
    else
        echo "Unable to determine the hop count."
    fi
fi
