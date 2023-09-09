#!/bin/bash

# Get your public IP address using curl
host=$(curl -s ifconfig.me)

# Function to anonymize the host by replacing numbers with #
anonymize_host() {
    local host="$1"
    local anon_flag="$2"

    if [ "$anon_flag" == "anon" ]; then
        anonymized_host=$(echo "$host" | sed 's/[0-9]/#/g')
    else
        anonymized_host="$host"
    fi

    echo "$anonymized_host"
}

# Define a function to detect CGNAT
detect_cgnat() {

    # Check if host is empty
    if [ -z "$host" ]; then
        echo "Unable to determine your public IP address."
        return
    fi

    echo "Public IP: $(anonymize_host "$host" "$anon_flag")"

    # Perform a traceroute to your public IP address
    hop_count=$(traceroute -n $host | tail -n 1 | awk '{print $1}')

    if [ -n "$hop_count" ]; then
        echo "Hops: $hop_count"

        # Check if CGNAT is detected
        if [ "$hop_count" -gt 2 ]; then
            echo "CGNAT detected!"
        else
            echo "No CGNAT detected!"
        fi
    else
        echo "Unable to determine the hop count."
    fi
}

# If the anon flag is provided as the first argument, use it; otherwise, don't anonymize
if [ $# -eq 1 ] && [ "$1" == "anon" ]; then
    anon_flag="anon"
else
    anon_flag="no_anon"
fi
# Call the function to detect CGNAT
detect_cgnat
