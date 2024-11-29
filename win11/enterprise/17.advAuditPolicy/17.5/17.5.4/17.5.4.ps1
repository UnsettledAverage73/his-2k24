# check.ps1

# Define the subcategory for auditing
$subcategory = "Logon"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success and Failure") {
    Write-Output "'Audit Logon' is correctly set to include 'Success and Failure'."
} elseif ($auditSettings -match "Success" -and $auditSettings -match "Failure") {
    Write-Output "'Audit Logon' includes both 'Success' and 'Failure'."
} else {
    Write-Output "'Audit Logon' is not configured as recommended. Current Output: $auditSettings"
}
