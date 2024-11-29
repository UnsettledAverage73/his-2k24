# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Security State Change"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:disable

Write-Output "'Audit Security State Change' has been set to include 'Success'."
