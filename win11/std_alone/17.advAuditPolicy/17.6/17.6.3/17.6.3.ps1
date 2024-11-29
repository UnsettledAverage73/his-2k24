# check.ps1

# Define the subcategory for auditing
$subcategory = "Audit Other Object Access Events"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success" -and $auditSettings -match "Failure") {
    Write-Output "'Audit Other Object Access Events' is correctly set to include 'Success and Failure'."
} else {
    Write-Output "'Audit Other Object Access Events' is not configured as recommended. Current Output: $auditSettings"
}
