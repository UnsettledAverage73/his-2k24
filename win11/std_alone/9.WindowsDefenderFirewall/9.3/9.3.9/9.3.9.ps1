# check.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging"
$regValueName = "LogSuccessfulConnections"

# Check if the registry key exists and if the value is set to 1 (Yes)
if (Test-Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue
    if ($currentValue.LogSuccessfulConnections -eq 1) {
        Write-Output "The setting 'Windows Firewall: Public: Logging: Log successful connections' is correctly set to 'Yes'."
    } else {
        Write-Output "The setting is not configured as recommended. Current Value: $($currentValue.LogSuccessfulConnections)"
    }
} else {
    Write-Output "The registry path does not exist. The setting may not be configured."
}
