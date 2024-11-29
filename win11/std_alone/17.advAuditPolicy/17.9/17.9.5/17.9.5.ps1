# check.ps1

# Define the subcategory for auditing
$subcategory = "System Integrity"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success and Failure") {
    Write-Output "'Audit System Integrity' is correctly set to 'Success and Failure'."
} else {
    Write-Output "'Audit System Integrity' is not configured as recommended. Current Output: $auditSettings"
}
