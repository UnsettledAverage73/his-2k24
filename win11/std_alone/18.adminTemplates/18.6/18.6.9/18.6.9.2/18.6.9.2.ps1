# check.ps1
# Script to check if "Turn on Responder (RSPNDR) driver" is disabled

# Registry keys and expected values
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD"
$Keys = @{
    AllowRspndrOnDomain = 0
    AllowRspndrOnPublicNet = 0
    EnableRspndr = 0
    ProhibitRspndrOnPrivateNet = 1
}

# Check each key
$errors = @()
foreach ($Key in $Keys.Keys) {
    if (Test-Path "$RegPath\$Key") {
        $value = Get-ItemProperty -Path $RegPath -Name $Key | Select-Object -ExpandProperty $Key
        if ($value -ne $Keys[$Key]) {
            $errors += "$Key is set to $value. Expected: $($Keys[$Key])."
        }
    } else {
        $errors += "$Key does not exist. Expected: $($Keys[$Key])."
    }
}

# Output results
if ($errors.Count -eq 0) {
    Write-Output "Pass: Responder (RSPNDR) driver is disabled as recommended."
} else {
    Write-Output "Fail: Issues detected with the following settings:"
    $errors | ForEach-Object { Write-Output $_ }
}
