# remedi.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
$regValueName = "LogFileSize"

# Check if the registry path exists, if not create it
if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the value to 16384 (16,384 KB)
Set-ItemProperty -Path $regPath -Name $regValueName -Value 16384

Write-Output "The setting 'Windows Firewall: Public: Logging: Size limit (KB)' has been set to 16,384 KB."
