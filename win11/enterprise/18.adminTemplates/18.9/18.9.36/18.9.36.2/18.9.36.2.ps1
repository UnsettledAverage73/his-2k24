# check.ps1
# Script to audit the setting of "Restrict Unauthenticated RPC Clients"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc"
$regValue = "RestrictRemoteClients"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Restrict Unauthenticated RPC Clients' is set to Enabled: Authenticated."
        } else {
            Write-Output "FAIL: 'Restrict Unauthenticated RPC Clients' is not set to Enabled: Authenticated."
        }
    } else {
        Write-Output "FAIL: 'Restrict Unauthenticated RPC Clients' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
