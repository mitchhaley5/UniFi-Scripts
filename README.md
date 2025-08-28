# UniFi Scripts

a collection of scripts that can be used to perform certain functions on the UniFi controller.




## Usage
The scripts are intended to be run on the UniFi controller itself
There are 2 methods for using the scripts:
#### 1. Download and Run Using BASH
Run the following commands in the shell:

`wget https://raw.githubusercontent.com/mitchhaley5/UniFi-Scripts/refs/heads/main/<scriptname>.sh`

`bash /path/to/<scriptname>.sh`

#### 2. (Single line) Run in a Temp File which is Removed when Execution is Complete run the following command in the shell:

_This command can be found in the 'Usage' section of the header of each script_
  
`TMP=$(mktemp) && curl -s https://raw.githubusercontent.com/mitchhaley5/UniFi-Scripts/refs/heads/main/<scriptname>.sh -o "$TMP" && bash "$TMP" && rm -f "$TMP"`
