# Title: Remediation Script for 'Shut down the system' Policy
# Description: This script sets the 'Shut down the system' policy to 'Administrators, Users'.

Write-Host "Starting Remediation: Configuring 'Shut down the system' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Shut down the system'
    Write-Host "Updating the policy for 'Shut down the system'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeShutdownPrivilege = ).*', "Administrators, Users"

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Shut down the system' policy is now set to 'Administrators, Users'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

