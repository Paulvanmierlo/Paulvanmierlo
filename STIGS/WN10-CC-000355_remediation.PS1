<#
.SYNOPSIS
    This PowerShell script disallows WinRM from storing RunAs credentials by configuring the registry to comply with STIG ID WN10-CC-000355.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-CC-000355

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-CC-000355.ps1
#>

# Registry path and values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$regName = "DisableRunAs"
$regValue = 1  # 1 = Disallow storing RunAs credentials

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create the registry path if it does not exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the value
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-CC-000355 remediated: WinRM is now configured to disallow storing RunAs credentials."
