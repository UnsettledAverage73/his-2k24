# Title: Remediation Script for 'Access Credential Manager as a Trusted Caller'
# Description: This script sets the policy to 'No One' as per CIS Benchmark guidelines.

# Define the registry path and key
$policyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Credssp\PolicyDefaults"
$registryKey = "AccessCredentialManagerAsTrustedCaller"

Write-Output "Starting Remediation for 'Access Credential Manager as a Trusted Caller'..."

try {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $policyPath)) {
        Write-Output "Policy path not found. Creating the path..."
        New-Item -Path $policyPath -Force | Out-Null
    }

    # Set the registry value to 'No one'
    Set-ItemProperty -Path $policyPath -Name $registryKey -Value "No one" -Force
    Write-Output "Remediation: Successfully set 'Access Credential Manager as a Trusted Caller' to 'No One'."
} catch {
    Write-Output "An error occurred during remediation: $_"
}

