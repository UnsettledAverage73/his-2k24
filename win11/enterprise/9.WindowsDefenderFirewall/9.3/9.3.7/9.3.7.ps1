# check.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
$regValueName = "LogFileSize"

# Check if the registry key exists and if the value is 16384 or greater
if (Test-Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue
    if ($currentValue.LogFileSize -ge 16384) {
        Write-Output "The setting 'Windows Firewall: Public: Logging: Size limit (KB)' is correctly set to 16,384 KB or greater. Current Value: $($currentValue.LogFileSize)"
    } else {
        Write-Output "The setting is not configured as recommended. Current Value: $($currentValue.LogFileSize)"
    }
} else {
    Write-Output "The registry path does not exist. The setting may not be configured."
}
