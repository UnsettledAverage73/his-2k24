# remedi.ps1

# Set 'Audit Application Group Management' to log Success and Failure
$subcategory = "Application Group Management"

Write-Output "Configuring 'Audit Application Group Management' to log Success and Failure..."
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit Application Group Management' has been set to 'Success and Failure'."
