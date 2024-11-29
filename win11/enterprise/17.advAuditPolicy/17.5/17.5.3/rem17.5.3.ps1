# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Logoff"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Logoff' has been set to include 'Success'."
