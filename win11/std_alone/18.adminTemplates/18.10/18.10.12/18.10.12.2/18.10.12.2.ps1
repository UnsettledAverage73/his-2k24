# check.ps1
# Script to audit the setting of "Turn off cloud optimized content" and ensure it's set to Enabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$regValue = "DisableCloudOptimizedContent"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Turn off cloud optimized content' is set to Enabled."
        } else {
            Write-Output "FAIL: 'Turn off cloud optimized content' is not set to Enabled."
        }
    } else {
        Write-Output "FAIL: 'Turn off cloud optimized content' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
