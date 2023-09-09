# Network Scripts

## CGNAT

The following scripts are designed to detect Carrier-Grade Network Address Translation (CGNAT) for your public IP address. CGNAT is a technology used by internet service providers to conserve IPv4 addresses by sharing a single public IP address among multiple customers. These scripts help identify whether your public IP address is subject to CGNAT, providing valuable information about your network configuration and helping troubleshoot connectivity issues.

### Linux

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/linux/cgnat.sh | bash -s -- -anon
```

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/linux/cgnat.sh | bash
```

### Windows

```shell
 curl -o cgnat.bat https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/win/cgnat.bat ; .\cgnat.bat
```

## Portforwarding

The following scripts are designed to check whether a specific port and its associated type are open on a target device or server. This is useful for network administrators and security professionals to verify if a particular service or application is accessible and available for communication over a network connection. By running these scripts, you can determine if the desired port is accepting incoming connections, helping to diagnose network connectivity and accessibility.

### Linux

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/linux/portchecker.sh | bash -s 443 tcp -anon
```

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/linux/portchecker.sh | bash -s 443 tcp
```
