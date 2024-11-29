# Title: Remediation Script for 'Create global objects' Policy
# Description: This script configures the 'Create global objects' policy to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'

Write-Host "Starting Remediation: Setting 'Create global objects' policy" -ForegroundColor Yellow

# Define the expected user rights assignment
$expectedSetting = "Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE"

try {
    # Export the current security policy configuration
    secedit /export /cfg "C:\Windows\Security\Local Policies\export.inf"
    
    # Load the exported policy
    $exportedContent = Get-Content "C:\Windows\Security\Local Policies\export.inf"

    # Update the policy for 'Create global objects' to include the required accounts
    $updatedContent = $exportedContent -replace '(?<=SeCreateGlobalPrivilege = ).*', $expectedSetting

    # Save the updated policy
    $updatedContent | Set-Content "C:\Windows\Security\Local Policies\import.inf"

    # Import the updated policy
    secedit /configure /db secedit.sdb /cfg "C:\Windows\Security\Local Policies\import.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Create global objects' policy is now set to '$expectedSetting'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the 'Create global objects' policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

