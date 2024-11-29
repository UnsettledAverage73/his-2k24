# check.ps1

# Define the subcategory for auditing
$subcategory = "Other Policy Change Events"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Failure") {
    Write-Output "'Audit Other Policy Change Events' is correctly set to include 'Failure'."
} else {
    Write-Output "'Audit Other Policy Change Events' is not configured as recommended. Current Output: $auditSettings"
}
