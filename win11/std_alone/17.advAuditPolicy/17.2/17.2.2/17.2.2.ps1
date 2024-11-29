# check.ps1

# Check the current setting for Audit Security Group Management
$subcategory = "Security Group Management"
$currentSetting = auditpol /get /subcategory:"$subcategory" | Select-String -Pattern "Audit Policy"

if ($currentSetting -match "Success") {
    Write-Output "'Audit Security Group Management' is correctly set to include 'Success'."
} else {
    Write-Output "'Audit Security Group Management' is not configured as recommended. Current Setting: $currentSetting"
}
