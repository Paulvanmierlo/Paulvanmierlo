<#
.SYNOPSIS
    This PowerShell script configures the LAN Manager authentication level to use NTLMv2 only and refuse LM and NTLM, to comply with STIG ID WN10-SO-000205.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-SO-000205

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11 (22H2)
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-SO-000205.ps1
#>

# Registry settings for LAN Manager authentication level
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regName = "LmCompatibilityLevel"
$regValue = 5  # Value 5 = Send NTLMv2 response only. Refuse LM & NTLM

# Check for Admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply registry value
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-SO-000205 remediated: LAN Manager authentication level set to NTLMv2 only (value: 5)."
