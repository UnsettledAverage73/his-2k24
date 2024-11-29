# Title: Remediation Script for 'Take ownership of files or other objects' Policy
# Description: This script sets the 'Take ownership of files or other objects' policy to 'Administrators'.

Write-Host "Starting Remediation: Configuring 'Take ownership of files or other objects' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Take ownership of files or other objects'
    Write-Host "Updating the policy for 'Take ownership of files or other objects'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeTakeOwnershipPrivilege = ).*', "Administrators"

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Take ownership of files or other objects' policy is now set to 'Administrators'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

