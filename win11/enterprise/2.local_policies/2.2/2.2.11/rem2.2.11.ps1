# Title: Remediation Script for 'Create a token object' Policy
# Description: This script configures the 'Create a token object' policy to 'No One'

Write-Host "Starting Remediation: Setting 'Create a token object' policy" -ForegroundColor Yellow

# Define the expected user rights assignment
$expectedSetting = "No One"

try {
    # Export the current security policy configuration
    secedit /export /cfg "C:\Windows\Security\Local Policies\export.inf"
    
    # Load the exported policy
    $exportedContent = Get-Content "C:\Windows\Security\Local Policies\export.inf"

    # Update the policy for 'Create a token object' to 'No One'
    $updatedContent = $exportedContent -replace '(?<=SeCreateTokenPrivilege = ).*', $expectedSetting

    # Save the updated policy
    $updatedContent | Set-Content "C:\Windows\Security\Local Policies\import.inf"

    # Import the updated policy
    secedit /configure /db secedit.sdb /cfg "C:\Windows\Security\Local Policies\import.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Create a token object' policy is now set to '$expectedSetting'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the 'Create a token object' policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

