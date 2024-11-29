# check.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
$regValueName = "AllowLocalPolicyMerge"

# Check if the registry key exists and if the value is set to 0 (No)
if (Test-Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue
    if ($currentValue.AllowLocalPolicyMerge -eq 0) {
        Write-Output "The setting 'Windows Firewall: Public: Settings: Apply local firewall rules' is set to 'No'."
    } else {
        Write-Output "The setting is not correctly set. Current value is: $($currentValue.AllowLocalPolicyMerge)"
    }
} else {
    Write-Output "The registry path does not exist. The setting may not be configured."
}
