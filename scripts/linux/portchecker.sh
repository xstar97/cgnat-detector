#!/bin/bash

# Initialize the anon flag to false
anon=false
port=""
protocol=""

# Check if the anon flag is provided as an argument
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -anon|--anonymous)
            anon=true
            shift
            ;;
        *)
            if [ -z "$port" ]; then
                port="$1"
                shift
            elif [ -z "$protocol" ]; then
                protocol="$1"
                shift
            else
                # Ignore any additional arguments
                shift
            fi
            ;;
    esac
done

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

    # Check if nc is available
    if ! command -v nc &> /dev/null; then
        echo "Error: 'nc' command is not available. Please install netcat (nc)."
        exit 1
    fi

    $nc_command "$host" "$port" >/dev/null 2>&1

    if [ "$anon" = true ]; then
        host="##.##.##.###"
    fi

    if [ $? -eq 0 ]; then
        echo "$protocol Port $port is open on $host"
    else
        echo "$protocol Port $port is closed on $host"
    fi
}

# Check if the script is provided with the required arguments
if [ -z "$port" ] || [ -z "$protocol" ]; then
    echo "Usage: $0 <port> <tcp/udp>"
    exit 1
fi

check_port "$port" "$protocol"
