# Title: Remediation Script for 'Allow log on locally'
# Description: Configures the policy to 'Administrators, Users'.

# Define the policy name
$policyName = "Allow log on locally"
$requiredUsers = "Administrators, Users"

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
    Write-Output "Remediation: Successfully set '$policyName' to the recommended configuration."
} catch {
    Write-Output "An error occurred during remediation: $_"
} finally {
    # Clean up temporary files
    Remove-Item -Path "$env:temp\secpol.cfg" -Force -ErrorAction SilentlyContinue
}

