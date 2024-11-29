# remedi.ps1

# Define the subcategory for auditing
$subcategory = "MPSSVC Rule-Level Policy Change"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit MPSSVC Rule-Level Policy Change' has been set to include 'Success' and 'Failure'."
