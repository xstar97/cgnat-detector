#!/bin/bash

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # This is a Linux system
    echo "Running on Linux"
	curl -sSL https://raw.githubusercontent.com/xstar97/cgnat-detector/main/scripts/linux/cgnat.sh | bash

elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # This is a Windows system using MinGW or Cygwin
    echo "Running on Windows"
	curl -s -o cgnat.bat -LJO https://github.com/xstar97/cgnat-detector/raw/main/scripts/win/cgnat.bat && chmod +x cgnat.bat && ./cgnat.bat
else
    echo "Unsupported operating system"
fi
