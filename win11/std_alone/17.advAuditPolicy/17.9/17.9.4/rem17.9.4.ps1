# remedi.ps1

# Define the subcategory for auditing
$subcategory = "Security System Extension"

# Apply the recommended configuration
auditpol /set /subcategory:"$subcategory" /success:enable /failure:disable

Write-Output "'Audit Security System Extension' has been set to include 'Success'."
