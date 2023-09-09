#!/bin/bash

# Define the internal host
host=$(curl -s ifconfig.me)

# Function to anonymize the host by replacing numbers with #
anonymize_host() {
    local host="$1"
    local anon_flag="$2"

    if [ "$anon_flag" == "anon" ]; then
        anonymized_host=${host//[0-9]/#}
    else
        anonymized_host="$host"
    fi

    echo "$anonymized_host"
}

# Function to check if the TCP or UDP port is open
check_port() {
    local port="$1"
    local protocol="$2"

    if [ "$protocol" == "tcp" ]; then
        nc_command="nc -z -v -w 5"
    elif [ "$protocol" == "udp" ]; then
        nc_command="nc -u -z -v -w 5"
    else
        echo "Invalid protocol. Use 'tcp' or 'udp'."
        exit 1
    fi

    if $nc_command "$host" "$port" >/dev/null 2>&1; then
        echo "$protocol Port $port is open on $(anonymize_host "$host" "$anon_flag")"
    else
        echo "$protocol Port $port is closed on $(anonymize_host "$host" "$anon_flag")"
    fi
}

# Check if the script is provided with the required arguments (2 or 3)
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Usage: $0 <port> <tcp/udp> [anon]"
    exit 1
fi

port="$1"
protocol="$2"

# If the anon flag is provided as the third argument, use it; otherwise, don't anonymize
if [ $# -eq 3 ] && [ "$3" == "anon" ]; then
    anon_flag="anon"
else
    anon_flag="no_anon"
fi

# Call the check_port function
check_port "$port" "$protocol"
