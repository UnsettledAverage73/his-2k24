#!/bin/bash

# Title: CIS Control 18.10.9.1.7 (BL) - Check 'Save BitLocker recovery info to AD DS' for fixed drives

echo "Checking compliance for: CIS Control 18.10.9.1.7 (BL) - Save BitLocker recovery info to AD DS"

reg_path="HKLM\\SOFTWARE\\Policies\\Microsoft\\FVE"
reg_value="FDVActiveDirectoryBackup"

# Check the registry value using reg query
current_value=$(reg query $reg_path /v $reg_value 2>/dev/null | grep $reg_value | awk '{print $3}')

if [ "$current_value" == "0x0" ]; then
    echo "Compliant: 'Save BitLocker recovery information to AD DS for fixed data drives' is set to 'Enabled: False'."
else
    echo "Non-Compliant: Current value is '$current_value'. It should be '0x0' (Enabled: False)."
fi

