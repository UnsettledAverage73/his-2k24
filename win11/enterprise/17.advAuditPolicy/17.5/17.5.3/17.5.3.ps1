# check.ps1

# Define the subcategory for auditing
$subcategory = "Logoff"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success") {
    Write-Output "'Audit Logoff' is correctly set to include 'Success'."
} else {
    Write-Output "'Audit Logoff' is not configured as recommended. Current Output: $auditSettings"
}
