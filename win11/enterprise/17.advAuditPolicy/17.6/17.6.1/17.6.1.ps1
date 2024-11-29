# check.ps1

# Define the subcategory for auditing
$subcategory = "Detailed File Share"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Failure") {
    Write-Output "'Audit Detailed File Share' is correctly set to include 'Failure'."
} else {
    Write-Output "'Audit Detailed File Share' is not configured as recommended. Current Output: $auditSettings"
}
