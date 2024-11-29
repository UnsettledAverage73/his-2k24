#!/bin/bash

# Title: CIS Control 18.10.9.1.7 (BL) - Remediate 'Save BitLocker recovery info to AD DS' for fixed drives

echo "Remediating: CIS Control 18.10.9.1.7 (BL) - Save BitLocker recovery info to AD DS"

reg_path="HKLM\\SOFTWARE\\Policies\\Microsoft\\FVE"
reg_value="FDVActiveDirectoryBackup"
desired_value=0

# Set the registry value using reg add
reg add $reg_path /v $reg_value /t REG_DWORD /d $desired_value /f

if [ $? -eq 0 ]; then
    echo "Remediated: 'Save BitLocker recovery information to AD DS for fixed data drives' is now set to 'Enabled: False'."
else
    echo "Error: Failed to set the registry value. Please check permissions and try again."
fi

