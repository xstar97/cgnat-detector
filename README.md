# Network Scripts

## CGNAT

The following scripts are designed to detect Carrier-Grade Network Address Translation (CGNAT) for your public IP address. CGNAT is a technology used by internet service providers to conserve IPv4 addresses by sharing a single public IP address among multiple customers. These scripts help identify whether your public IP address is subject to CGNAT, providing valuable information about your network configuration and helping troubleshoot connectivity issues.

### Linux

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/linux/cgnat.sh | bash
```

### Windows

```shell
 curl -o cgnat.bat https://raw.githubusercontent.com/xstar97/network-scripts/main/scripts/win/cgnat.bat ; .\cgnat.bat
```
