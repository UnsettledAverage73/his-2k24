# remedi.ps1

# Define the subcategory for auditing
$subcategory = "IPsec Driver"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:enable

Write-Output "'Audit IPsec Driver' has been set to include 'Success and Failure'."
