# Title: Audit Script for 'Act as part of the operating system'
# Description: This script checks if the policy is set to 'No One'.

# Define the policy name
$policyName = "Act as part of the operating system"

Write-Output "Starting Compliance Audit for '$policyName'..."

try {
    # Retrieve the policy setting
    $policyValue = secedit /export /cfg $env:temp\secpol.cfg | Out-Null
    $policyContent = Get-Content -Path "$env:temp\secpol.cfg"
    $configuredUsers = $policyContent -match ("$policyName\s*=\s*(.*)$") | ForEach-Object { $matches[1] }

    if ($configuredUsers -eq "") {
        Write-Output "Compliance Check: PASSED - '$policyName' is configured to 'No One'."
    } else {
        Write-Output "Compliance Check: FAILED - '$policyName' is not set to 'No One'."
        Write-Output "Current Value: $configuredUsers"
    }
} catch {
    Write-Output "An error occurred during the compliance audit: $_"
} finally {
    # Clean up temporary files
    Remove-Item -Path "$env:temp\secpol.cfg" -Force -ErrorAction SilentlyContinue
}

