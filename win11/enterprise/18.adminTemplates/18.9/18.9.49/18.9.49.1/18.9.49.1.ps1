# check.ps1
# Script to audit the setting of "Turn off the advertising ID"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
$regValue = "DisabledByGroupPolicy"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Turn off the advertising ID' is set to Enabled."
        } else {
            Write-Output "FAIL: 'Turn off the advertising ID' is not set to Enabled."
        }
    } else {
        Write-Output "FAIL: 'Turn off the advertising ID' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
