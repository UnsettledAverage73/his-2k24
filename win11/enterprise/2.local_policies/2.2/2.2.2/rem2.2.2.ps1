# Title: Remediation Script for 'Access this computer from the network'
# Description: This script configures the policy to 'Administrators, Remote Desktop Users'.

# Define the policy name and required users
$policyName = "Access this computer from the network"
$requiredUsers = "Administrators,Remote Desktop Users"

Write-Output "Starting Remediation for '$policyName'..."

try {
    # Export the current security policy
    secedit /export /cfg $env:temp\secpol.cfg | Out-Null

    # Update the policy setting
    $policyContent = Get-Content -Path "$env:temp\secpol.cfg"
    $updatedPolicy = $policyContent -replace "($policyName\s*=\s*).*$", "`$1$requiredUsers"
    $updatedPolicy | Set-Content -Path "$env:temp\secpol.cfg"

    # Import the updated security policy
    secedit /configure /db $env:windir\security\database\secedit.sdb /cfg $env:temp\secpol.cfg /areas User_Rights | Out-Null
    Write-Output "Remediation: Successfully set '$policyName' to '$requiredUsers'."
} catch {
    Write-Output "An error occurred during remediation: $_"
} finally {
    # Clean up temporary files
    Remove-Item -Path "$env:temp\secpol.cfg" -Force -ErrorAction SilentlyContinue
}

