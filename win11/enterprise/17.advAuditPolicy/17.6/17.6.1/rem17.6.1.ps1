# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Detailed File Share"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /failure:enable

Write-Output "'Audit Detailed File Share' has been set to include 'Failure'."
