# Title: Remediation Script for 'Deny log on through Remote Desktop Services' Policy
# Description: This script configures the 'Deny log on through Remote Desktop Services' policy to include 'Guests, Local account' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Deny log on through Remote Desktop Services' policy" -ForegroundColor Yellow

# Define the expected accounts
$expectedAccounts = @("Guests", "Local account")

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Deny log on through Remote Desktop Services'
    Write-Host "Updating the policy to include 'Guests, Local account'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeDenyRemoteInteractiveLogonRight = ).*', ($expectedAccounts -join ',')

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Deny log on through Remote Desktop Services' policy is now configured correctly." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

