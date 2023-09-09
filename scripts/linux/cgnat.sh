#!/bin/bash

# Initialize the anon flag to false
anon=false

# Check if the anon flag is provided as an argument
if [[ "$*" == *"-anon"* ]]; then
    anon=true
fi

# Get your public IP address using curl
public_ip=$(curl -s ifconfig.me)

# Check if public_ip is empty
if [ -z "$public_ip" ]; then
    echo "Unable to determine your public IP address."
else
    if [ "$anon" = true ]; then
        echo "Public IP: ##.##.##.###"
    else
        echo "Public IP: $public_ip"
    fi

    # Perform a traceroute to your public IP address
    hop_count=$(traceroute -n $public_ip | tail -n 1 | awk '{print $1}')
    
    if [ -n "$hop_count" ]; then
        echo "Hops: $hop_count"
        
        # Check if CGNAT is detected
        if [ "$hop_count" -gt 2 ]; then
            echo "CGNAT Alert: CGNAT detected. Please review your network configuration."
        else
            echo "CGNAT status: No CGNAT detected."
        fi
    else
        echo "Unable to determine the hop count."
    fi
fi
