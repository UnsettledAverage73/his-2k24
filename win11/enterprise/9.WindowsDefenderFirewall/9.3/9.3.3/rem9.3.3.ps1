# remedi.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
$regValueName = "DisableNotifications"

# Check if the registry path exists
if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the value to 1 (No notifications)
Set-ItemProperty -Path $regPath -Name $regValueName -Value 1

Write-Output "The setting 'Windows Firewall: Public: Settings: Display a notification' has been set to 'No'."
