# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Logon"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Logon' has been set to include 'Success and Failure'."
