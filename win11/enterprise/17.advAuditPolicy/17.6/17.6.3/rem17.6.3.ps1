# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Audit Other Object Access Events"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Other Object Access Events' has been set to include 'Success and Failure'."
