# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Special Logon"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Special Logon' has been set to include 'Success'."
