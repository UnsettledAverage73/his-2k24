# check.ps1

# Define the subcategory for auditing
$subcategory = "Removable Storage"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success" -and $auditSettings -match "Failure") {
    Write-Output "'Audit Removable Storage' is correctly set to include 'Success and Failure'."
} else {
    Write-Output "'Audit Removable Storage' is not configured as recommended. Current Output: $auditSettings"
}
