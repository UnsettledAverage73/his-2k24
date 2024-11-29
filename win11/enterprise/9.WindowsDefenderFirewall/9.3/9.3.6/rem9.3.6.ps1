# remedi.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
$regValueName = "AllowLocalIPsecPolicyMerge"

# Check if the registry path exists, if not create it
if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the value to 0 (No local connection security rules)
Set-ItemProperty -Path $regPath -Name $regValueName -Value 0

Write-Output "The setting 'Windows Firewall: Public: Settings: Apply local connection security rules' has been set to 'No'."
