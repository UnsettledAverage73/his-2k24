# remedi.ps1

# Define the subcategory for auditing
$subcategory = "File Share"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit File Share' has been set to include 'Success and Failure'."
