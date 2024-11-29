# check.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
$regValueName = "DisableNotifications"

# Check if the registry key exists and if the value is set to 1 (No notification)
if (Test-Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue
    if ($currentValue.DisableNotifications -eq 1) {
        Write-Output "The setting 'Windows Firewall: Public: Settings: Display a notification' is set to 'No'."
    } else {
        Write-Output "The setting is not correctly set. Current value is: $($currentValue.DisableNotifications)"
    }
} else {
    Write-Output "The registry path does not exist. The setting may not be configured."
}
