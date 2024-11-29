# check.ps1

# Define the subcategory for auditing
$subcategory = "File Share"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success" -and $auditSettings -match "Failure") {
    Write-Output "'Audit File Share' is correctly set to include 'Success and Failure'."
} else {
    Write-Output "'Audit File Share' is not configured as recommended. Current Output: $auditSettings"
}
