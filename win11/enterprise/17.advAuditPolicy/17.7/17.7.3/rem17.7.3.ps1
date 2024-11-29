# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Authorization Policy Change"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Authorization Policy Change' has been set to include 'Success'."
