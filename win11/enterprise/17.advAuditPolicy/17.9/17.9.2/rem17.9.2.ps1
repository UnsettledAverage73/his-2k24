# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Other System Events"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Other System Events' has been set to include 'Success and Failure'."
