# UniFi Scripts

a collection of scripts that can be used to perform certain functions on the UniFi controller




## Usage
There are 2 methods for using the scripts:
#### 1. Download and Run Using BASH
Run the following commands in the shell as root:

`wget https://raw.githubusercontent.com/mitchhaley5/UniFi-Scripts/refs/heads/main/<scriptname>.sh`

`bash /path/to/<scriptname>.sh`

#### 2. (Single line) Run in a Temp File which is Removed when Execution is Complete
run the following command in the shell as root:

`TMP=$(mktemp) && curl -s https://raw.githubusercontent.com/username/repo/branch/<scriptname>.sh -o "$TMP" && bash "$TMP" && rm -f "$TMP"`
