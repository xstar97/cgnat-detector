#!/bin/bash

# List of services to try
services=("ifconfig.me/ip" "ipinfo.io/ip" "icanhazip.com")

# Regular expression for IPv4
ipv4_regex="^([0-9]{1,3}[.]){3}[0-9]{1,3}$"

# Fetch IP address function
fetch_ip() {
    for service in "${services[@]}"; do
        local ip

        ip=$(curl -4 -s "$service")

        if [[ "$ip" =~ $ipv4_regex ]]; then
            echo "$ip"
            return 0
        fi
    done
    return 1
}

# Main CGNAT detection function
detect_cgnat() {
    local ip="$1"
    
    echo "Public IP: $(anonymize_host "$ip" "$anon_flag")"

    local hop_count

    hop_count=$(traceroute -n "$ip" | tail -n 1 | awk '{print $1}')
    
    if [ -n "$hop_count" ]; then
        echo "Hops: $hop_count"

        if [ "$hop_count" -gt 2 ]; then
            echo "CGNAT detected!"
        else
            echo "No CGNAT detected!"
        fi
    else
        echo "Unable to determine the hop count."
    fi
}

# Host anonymization function
anonymize_host() {
    local host="$1"
    local anon_flag="$2"
    
    [[ "$anon_flag" == "anon" ]] && echo "${host//[0-9]/#}" || echo "$host"
}

if ! host=$(fetch_ip); then
    echo "Failed to retrieve a valid IPv4 address."
    exit 1
fi

# Check if the anon flag is provided as the first argument
anon_flag="${1:-no_anon}"

# Call the function to detect CGNAT
detect_cgnat "$host"
