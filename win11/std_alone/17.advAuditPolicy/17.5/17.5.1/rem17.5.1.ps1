# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Account Lockout"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /failure:enable

Write-Output "'Audit Account Lockout' has been set to include 'Failure'."
