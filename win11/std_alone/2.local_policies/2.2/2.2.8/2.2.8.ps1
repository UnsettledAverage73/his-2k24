# Title: Audit Script for 'Change the system time'
# Description: Checks if the 'Change the system time' policy is set to 'Administrators, LOCAL SERVICE'.

# Define the policy name
$policyName = "Change the system time"

Write-Output "Starting Compliance Audit for '$policyName'..."

try {
    # Export the current security policy
    secedit /export /cfg $env:temp\secpol.cfg | Out-Null
    $policyContent = Get-Content -Path "$env:temp\secpol.cfg"

    # Retrieve the configured users/groups
    $configuredUsers = $policyContent -match ("$policyName\s*=\s*(.*)$") | ForEach-Object { $matches[1] }

    # Define the required configuration
    $requiredUsers = "Administrators, LOCAL SERVICE"

    if ($configuredUsers -eq $requiredUsers) {
        Write-Output "Compliance Check: PASSED - '$policyName' is configured as recommended."
    } else {
        Write-Output "Compliance Check: FAILED - '$policyName' is not set correctly."
        Write-Output "Current Value: $configuredUsers"
        Write-Output "Expected Value: $requiredUsers"
    }
} catch {
    Write-Output "An error occurred during the compliance audit: $_"
} finally {
    # Clean up temporary files
    Remove-Item -Path "$env:temp\secpol.cfg" -Force -ErrorAction SilentlyContinue
}

