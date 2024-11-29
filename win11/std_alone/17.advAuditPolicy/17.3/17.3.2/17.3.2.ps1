# check.ps1

# Define the subcategory for auditing
$subcategory = "Process Creation"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success") {
    Write-Output "'Audit Process Creation' is correctly set to include 'Success'."
} else {
    Write-Output "'Audit Process Creation' is not configured as recommended. Current Output: $auditSettings"
}
