# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Authentication Policy Change"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Authentication Policy Change' has been set to include 'Success'."
