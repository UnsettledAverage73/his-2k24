# check.ps1

# Check the current setting for Audit Application Group Management
$subcategory = "Application Group Management"
$currentSetting = auditpol /get /subcategory:"$subcategory" | Select-String -Pattern "Audit Policy"

if ($currentSetting -match "Success and Failure") {
    Write-Output "'Audit Application Group Management' is correctly set to 'Success and Failure'."
} else {
    Write-Output "'Audit Application Group Management' is not configured as recommended. Current Setting: $currentSetting"
}
