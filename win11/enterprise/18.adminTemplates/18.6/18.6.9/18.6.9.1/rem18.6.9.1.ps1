# remedi.ps1
# Script to disable "Turn on Mapper I/O (LLTDIO) driver"

# Registry keys and desired values
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD"
$Keys = @{
    AllowLLTDIOOnDomain = 0
    AllowLLTDIOOnPublicNet = 0
    EnableLLTDIO = 0
    ProhibitLLTDIOOnPrivateNet = 1
}

# Ensure the registry path exists and apply settings
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

foreach ($Key in $Keys.Keys) {
    Set-ItemProperty -Path $RegPath -Name $Key -Value $Keys[$Key] -Type DWord
}

# Verify remediation
$errors = @()
foreach ($Key in $Keys.Keys) {
    $value = Get-ItemProperty -Path $RegPath -Name $Key | Select-Object -ExpandProperty $Key
    if ($value -ne $Keys[$Key]) {
        $errors += "$Key is set to $value. Expected: $($Keys[$Key])."
    }
}

if ($errors.Count -eq 0) {
    Write-Output "Remediation successful: Mapper I/O (LLTDIO) driver is disabled."
} else {
    Write-Output "Remediation failed: Issues detected with the following settings:"
    $errors | ForEach-Object { Write-Output $_ }
}
