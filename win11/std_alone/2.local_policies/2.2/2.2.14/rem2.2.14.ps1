# Title: Remediation Script for 'Create symbolic links' Policy
# Description: This script configures the 'Create symbolic links' policy as per CIS recommendations.

Write-Host "Starting Remediation: Setting 'Create symbolic links' policy" -ForegroundColor Yellow

# Define the expected user rights assignment based on system configuration
$hyperVInstalled = (Get-WindowsFeature -Name Hyper-V).Installed
$expectedSetting = if ($hyperVInstalled) {
    "Administrators, NT VIRTUAL MACHINE\Virtual Machines"
} else {
    "Administrators"
}

try {
    # Export the current security policy configuration
    secedit /export /cfg "C:\Windows\Security\Local Policies\export.inf"
    
    # Load the exported policy
    $exportedContent = Get-Content "C:\Windows\Security\Local Policies\export.inf"

    # Update the policy for 'Create symbolic links' to include the required setting
    $updatedContent = $exportedContent -replace '(?<=SeCreateSymbolicLinkPrivilege = ).*', $expectedSetting

    # Save the updated policy
    $updatedContent | Set-Content "C:\Windows\Security\Local Policies\import.inf"

    # Import the updated policy
    secedit /configure /db secedit.sdb /cfg "C:\Windows\Security\Local Policies\import.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Create symbolic links' policy is now set to '$expectedSetting'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the 'Create symbolic links' policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

