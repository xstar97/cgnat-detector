#!/bin/bash


# Fetches and returns a valid public IPv4 address from a list of services.
fetch_ip() {
    local services=("ifconfig.me/ip" "ipinfo.io/ip" "icanhazip.com")
    local ipv4_regex="^([0-9]{1,3}[.]){3}[0-9]{1,3}$"

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

# Anonymizes the IP address by replacing numbers with '#'. Otherwise, returns the IP as it is.
anonymize_host() {
    [[ "$anon_flag" == "anon" ]] && echo "${host//[0-9]/#}" || echo "$host"
}

validate_port() {
    local port="$1"

    # Check if it's a number
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "Error: The provided port ($port) is not a valid number."
        return 1
    fi

    # Check if it's within the valid range
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Error: The provided port ($port) is out of the valid range (1-65535)."
        return 1
    fi

    return 0
}

usage() {
    echo "Usage: $0 <port> <tcp/udp> [anon]"
    exit 1
}

# Checks if the specified port is open for the given protocol (TCP/UDP) on the fetched public IP.
check_port() {
    local nc_command
    
    case "$protocol" in
        tcp) nc_command="nc -z -v -w 5" ;;
        udp) nc_command="nc -u -z -v -w 5" ;;
        *) echo "Invalid protocol. Use 'tcp' or 'udp'."; exit 1 ;;
    esac

    if $nc_command "$host" "$port" >/dev/null 2>&1; then
        echo "$protocol Port $port is open on $(anonymize_host)"
    else
        echo "$protocol Port $port is closed on $(anonymize_host)"
    fi
}

# Validate input arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    usage
fi

# Fetch IP
if ! host=$(fetch_ip); then
    echo "Failed to retrieve a valid IPv4 address."
    exit 1
fi

port="$1"
if ! validate_port "$port"; then
    usage
fi

protocol="${2,,}"
anon_flag=$(echo "${3:-no_anon}" | tr '[:upper:]' '[:lower:]')

# Check the port status
check_port
