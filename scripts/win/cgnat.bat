@echo off
setlocal enabledelayedexpansion

rem Get your public IP address
for /f %%a in ('curl ifconfig.me 2^>nul') do (
    set "public_ip=%%a"
)

rem Perform a traceroute to your public IP address
if defined public_ip (
    for /f "tokens=1" %%a in ('tracert !public_ip! ^| findstr /R /C:" [0-9]*$"') do (
        set "count_hop=%%a"
    )
) else (
    set "count_hop="
)

if defined public_ip (
    echo Public IP: !public_ip!
) else (
    echo Unable to determine your public IP address.
)

rem Display the last hop count and your public IP
if defined count_hop (
    echo The hop count is: !count_hop!
) else (
    echo Unable to determine the hop count.
)

rem Check if CGNAT is detected
if defined count_hop (
    set /a count_hop=count_hop
    if !count_hop! gtr 2 (
        echo CGNAT Alert: CGNAT detected. Please review your network configuration.
    ) else (
        echo CGNAT status: No CGNAT detected.
    )
) else (
    echo Unable to check for CGNAT detection due to an error.
)
