# remedi.ps1

# Define the subcategory for auditing
$subcategory = "System Integrity"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit System Integrity' has been set to 'Success and Failure'."
