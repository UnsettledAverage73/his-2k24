# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Sensitive Privilege Use"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Sensitive Privilege Use' has been set to include 'Success and Failure'."
