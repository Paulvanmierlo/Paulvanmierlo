<#
.SYNOPSIS
    This PowerShell script configures supported Kerberos encryption types to disable DES and RC4, allowing only AES128, AES256, and future encryption types, to comply with STIG ID WN10-SO-000190.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-SO-000190

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11
    PowerShell Ver. : 5.1+

.USAGE
    Run as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-SO-000190.ps1
#>

# Define registry path and required value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
$regName = "SupportedEncryptionTypes"
$regValue = 2147483640  # 0x7FFFFFF8 = AES128 + AES256 + Future types only

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the secure encryption types setting
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-SO-000190 remediated: Kerberos encryption types restricted to AES128, AES256, and future types."
