# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Group Membership"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Group Membership' has been set to include 'Success'."
