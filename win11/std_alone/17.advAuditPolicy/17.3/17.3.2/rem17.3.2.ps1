# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Process Creation"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Process Creation' has been set to include 'Success'."
