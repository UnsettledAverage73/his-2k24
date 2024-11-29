# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Removable Storage"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Removable Storage' has been set to include 'Success and Failure'."
