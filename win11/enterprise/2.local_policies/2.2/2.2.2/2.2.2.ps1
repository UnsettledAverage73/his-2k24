# Title: Audit Script for 'Access this computer from the network'
# Description: This script checks whether the policy is set to 'Administrators, Remote Desktop Users'.

# Define the policy name
$policyName = "Access this computer from the network"

Write-Output "Starting Compliance Audit for '$policyName'..."

try {
    # Retrieve the policy setting
    $policyValue = secedit /export /cfg $env:temp\secpol.cfg | Out-Null
    $policyContent = Get-Content -Path "$env:temp\secpol.cfg"
    $configuredUsers = $policyContent -match ("$policyName\s*=\s*(.*)$") | ForEach-Object { $matches[1] }

    if ($configuredUsers -match "Administrators" -and $configuredUsers -match "Remote Desktop Users") {
        Write-Output "Compliance Check: PASSED - '$policyName' is configured correctly."
    } else {
        Write-Output "Compliance Check: FAILED - '$policyName' is not set to 'Administrators, Remote Desktop Users'."
        Write-Output "Current Value: $configuredUsers"
    }
} catch {
    Write-Output "An error occurred during the compliance audit: $_"
} finally {
    # Clean up temporary files
    Remove-Item -Path "$env:temp\secpol.cfg" -Force -ErrorAction SilentlyContinue
}

