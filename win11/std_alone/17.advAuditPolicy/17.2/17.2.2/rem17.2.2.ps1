# remedi.ps1

# Set 'Audit Security Group Management' to include Success
$subcategory = "Security Group Management"

Write-Output "Configuring 'Audit Security Group Management' to include Success..."
auditpol /set /subcategory:"$subcategory" /success:enable

Write-Output "'Audit Security Group Management' has been set to include 'Success'."
