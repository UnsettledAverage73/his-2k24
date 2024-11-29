# remedi.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
$regValueName = "LogSuccessfulConnections"

# Check if the registry path exists, if not create it
if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the value to 1 (Yes)
Set-ItemProperty -Path $regPath -Name $regValueName -Value 1

Write-Output "The setting 'Windows Firewall: Public: Logging: Log successful connections' has been set to 'Yes'."
