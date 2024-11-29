# check.ps1

# Check the current setting for Audit User Account Management
$subcategory = "User Account Management"
$currentSetting = auditpol /get /subcategory:"$subcategory" | Select-String -Pattern "Audit Policy"

if ($currentSetting -match "Success and Failure") {
    Write-Output "'Audit User Account Management' is correctly set to 'Success and Failure'."
} else {
    Write-Output "'Audit User Account Management' is not configured as recommended. Current Setting: $currentSetting"
}
