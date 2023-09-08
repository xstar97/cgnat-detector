#!/bin/bash

# Define the internal host
host=$(curl -s ifconfig.me)

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

    $nc_command "$host" "$port"
    if [ $? -eq 0 ]; then
        echo "$protocol Port $port is open on $host"
    else
        echo "$protocol Port $port is closed on $host"
    fi
}

# Check if the script is provided with the required arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <port> <tcp/udp>"
    exit 1
fi

port="$1"
protocol="$2"

check_port "$port" "$protocol"
