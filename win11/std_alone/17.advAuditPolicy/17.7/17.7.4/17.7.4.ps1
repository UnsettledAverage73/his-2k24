# check.ps1

# Define the subcategory for auditing
$subcategory = "MPSSVC Rule-Level Policy Change"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success" -and $auditSettings -match "Failure") {
    Write-Output "'Audit MPSSVC Rule-Level Policy Change' is correctly set to include 'Success' and 'Failure'."
} else {
    Write-Output "'Audit MPSSVC Rule-Level Policy Change' is not configured as recommended. Current Output: $auditSettings"
}
