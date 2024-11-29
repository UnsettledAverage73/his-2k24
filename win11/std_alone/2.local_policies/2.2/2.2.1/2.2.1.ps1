# Title: Audit Script for 'Access Credential Manager as a Trusted Caller'
# Description: This script checks whether the policy is configured as 'No One'.

# Define the registry path and key
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Credssp\PolicyDefaults"
$registryKey = "AccessCredentialManagerAsTrustedCaller"

Write-Output "Starting Compliance Audit for 'Access Credential Manager as a Trusted Caller'..."

try {
    # Check if the registry path exists
    if (Test-Path $policyPath) {
        # Retrieve the registry value
        $policyValue = Get-ItemProperty -Path $policyPath -Name $registryKey -ErrorAction Stop
        if ($policyValue.AccessCredentialManagerAsTrustedCaller -eq "No one") {
            Write-Output "Compliance Check: PASSED - 'Access Credential Manager as a Trusted Caller' is set to 'No One'."
        } else {
            Write-Output "Compliance Check: FAILED - 'Access Credential Manager as a Trusted Caller' is not set to 'No One'."
            Write-Output "Current Value: $($policyValue.AccessCredentialManagerAsTrustedCaller)"
        }
    } else {
        Write-Output "Compliance Check: FAILED - The policy path does not exist."
    }
} catch {
    Write-Output "An error occurred during the compliance audit: $_"
}

