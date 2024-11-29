# check.ps1

# Define the subcategory for auditing
$subcategory = "Other Logon/Logoff Events"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success and Failure") {
    Write-Output "'Audit Other Logon/Logoff Events' is correctly set to include 'Success and Failure'."
} elseif ($auditSettings -match "Success" -and $auditSettings -match "Failure") {
    Write-Output "'Audit Other Logon/Logoff Events' includes both 'Success' and 'Failure'."
} else {
    Write-Output "'Audit Other Logon/Logoff Events' is not configured as recommended. Current Output: $auditSettings"
}
