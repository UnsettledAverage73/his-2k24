# check.ps1

# Define the subcategory for auditing
$subcategory = "Security System Extension"

# Retrieve the current audit settings
$auditSettings = auditpol /get /subcategory:"$subcategory" 2>&1

if ($auditSettings -match "Success") {
    Write-Output "'Audit Security System Extension' is correctly set to include 'Success'."
} else {
    Write-Output "'Audit Security System Extension' is not configured as recommended. Current Output: $auditSettings"
}
