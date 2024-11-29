# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Other Policy Change Events"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /failure:enable

Write-Output "'Audit Other Policy Change Events' has been set to include 'Failure'."
