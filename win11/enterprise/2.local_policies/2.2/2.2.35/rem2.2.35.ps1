# Title: Remediation Script for 'Profile system performance' Policy
# Description: This script sets the 'Profile system performance' policy to 'Administrators, NT SERVICE\WdiServiceHost'.

Write-Host "Starting Remediation: Configuring 'Profile system performance' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Profile system performance'
    Write-Host "Updating the policy for 'Profile system performance'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeSystemProfilePrivilege = ).*', "Administrators, NT SERVICE\WdiServiceHost"

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Profile system performance' policy is now set to 'Administrators, NT SERVICE\WdiServiceHost'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

