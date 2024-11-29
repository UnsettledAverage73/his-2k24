# remedi.ps1

# Set 'Audit Credential Validation' to log Success and Failure
$subcategory = "Credential Validation"

Write-Output "Configuring 'Audit Credential Validation' to log Success and Failure..."
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Credential Validation' has been set to 'Success and Failure'."
