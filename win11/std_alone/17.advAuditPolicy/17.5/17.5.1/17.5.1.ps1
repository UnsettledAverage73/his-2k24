# check.ps1

# Define the subcategory for auditing
$subcategory = "Account Lockout"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Failure") {
    Write-Output "'Audit Account Lockout' is correctly set to include 'Failure'."
} else {
    Write-Output "'Audit Account Lockout' is not configured as recommended. Current Output: $auditSettings"
}
