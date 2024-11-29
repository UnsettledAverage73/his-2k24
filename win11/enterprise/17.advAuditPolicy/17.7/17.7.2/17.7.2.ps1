# check.ps1

# Define the subcategory for auditing
$subcategory = "Authentication Policy Change"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success") {
    Write-Output "'Audit Authentication Policy Change' is correctly set to include 'Success'."
} else {
    Write-Output "'Audit Authentication Policy Change' is not configured as recommended. Current Output: $auditSettings"
}
