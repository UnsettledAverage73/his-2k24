# remedi.ps1

# Define the audit subcategory
$auditSubcategory = "PNP Activity"

# Apply the recommended setting to include 'Success'
Invoke-Expression "auditpol /set /subcategory:'$auditSubcategory' /success:enable"

Write-Output "'Audit PNP Activity' has been configured to include 'Success'."
