# Title: Remediation Script for 'Replace a process level token' Policy
# Description: This script sets the 'Replace a process level token' policy to 'LOCAL SERVICE, NETWORK SERVICE'.

Write-Host "Starting Remediation: Configuring 'Replace a process level token' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Replace a process level token'
    Write-Host "Updating the policy for 'Replace a process level token'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeReplaceProcessTokenPrivilege = ).*', "LOCAL SERVICE, NETWORK SERVICE"

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Replace a process level token' policy is now set to 'LOCAL SERVICE, NETWORK SERVICE'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

