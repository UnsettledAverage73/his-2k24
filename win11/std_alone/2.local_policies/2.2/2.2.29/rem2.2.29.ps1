# Title: Remediation Script for 'Log on as a service' Policy
# Description: This script sets the 'Log on as a service' policy to the recommended configuration based on the environment.

Write-Host "Starting Remediation: Configuring 'Log on as a service' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Determine the appropriate configuration
    $environment = Read-Host "Enter the environment type (Default/Hyper-V/WDAG)"
    switch ($environment.ToLower()) {
        "default" {
            $updatedPolicy = "*S-1-5-19,*S-1-5-20"  # NT SERVICE\ALL SERVICES
        }
        "hyper-v" {
            $updatedPolicy = "*S-1-5-83-0"  # NT VIRTUAL MACHINE\Virtual Machines
        }
        "wdag" {
            $updatedPolicy = "WDAGUtilityAccount"  # WDAGUtilityAccount
        }
        default {
            Write-Host "Invalid environment type specified. Exiting..." -ForegroundColor Red
            exit
        }
    }

    # Update the policy for 'Log on as a service'
    Write-Host "Updating the policy for 'Log on as a service'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeServiceLogonRight = ).*', $updatedPolicy

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Log on as a service' policy is now configured based on the specified environment." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

