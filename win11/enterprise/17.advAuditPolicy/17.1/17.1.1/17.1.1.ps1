# check.ps1

# Check the current setting for Audit Credential Validation
$subcategory = "Credential Validation"
$currentSetting = auditpol /get /subcategory:"$subcategory" | Select-String -Pattern "Audit Policy"

if ($currentSetting -match "Success and Failure") {
    Write-Output "'Audit Credential Validation' is correctly set to 'Success and Failure'."
} else {
    Write-Output "'Audit Credential Validation' is not configured as recommended. Current Setting: $currentSetting"
}
