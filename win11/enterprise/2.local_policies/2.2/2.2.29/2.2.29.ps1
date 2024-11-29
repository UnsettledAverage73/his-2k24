# Title: Audit Script for 'Log on as a service' Policy
# Description: This script checks if the 'Log on as a service' policy is set as per the CIS recommendation.

Write-Host "Starting Audit: 'Log on as a service' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeServiceLogonRight").ToString().Split('=')[1].Trim()

# Expected values
$expectedAccountsDefault = "*S-1-5-19,*S-1-5-20"  # Default value for NT SERVICE\ALL SERVICES
$expectedAccountsHyperV = "*S-1-5-83-0"          # NT VIRTUAL MACHINE\Virtual Machines
$expectedAccountsWDAG = "WDAGUtilityAccount"    # WDAGUtilityAccount for Windows Defender Application Guard

# Check if the policy matches any expected values
if ($currentAccounts -eq $expectedAccountsDefault) {
    Write-Host "PASS: 'Log on as a service' policy is set to the default (NT SERVICE\ALL SERVICES)." -ForegroundColor Green
} elseif ($currentAccounts -eq $expectedAccountsHyperV) {
    Write-Host "PASS: 'Log on as a service' policy is correctly set for Hyper-V (NT VIRTUAL MACHINE\Virtual Machines)." -ForegroundColor Green
} elseif ($currentAccounts -eq $expectedAccountsWDAG) {
    Write-Host "PASS: 'Log on as a service' policy is correctly set for Windows Defender Application Guard." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Log on as a service' policy is set to: $currentAccounts. It should match one of the recommended configurations." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

