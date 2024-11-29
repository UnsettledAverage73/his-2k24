# check.ps1

# Define the audit subcategory
$auditSubcategory = "PNP Activity"

# Get the current audit settings for the subcategory
$auditStatus = (auditpol /get /subcategory:"$auditSubcategory" 2>$null) | Select-String -Pattern "$auditSubcategory" | ForEach-Object { $_.ToString().Trim() }

if ($auditStatus -match "Success") {
    Write-Output "'Audit PNP Activity' is correctly set to include 'Success'."
} else {
    Write-Output "'Audit PNP Activity' is not set as recommended. Current Status: $auditStatus"
}
