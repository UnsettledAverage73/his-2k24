# remedi.ps1

# Set 'Audit User Account Management' to Success and Failure
$subcategory = "User Account Management"

Write-Output "Configuring 'Audit User Account Management' to 'Success and Failure'..."
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit User Account Management' has been set to 'Success and Failure'."
