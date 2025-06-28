<#
.SYNOPSIS
    This PowerShell script configures the Windows SMB client to always require SMB packet signing, as required by STIG ID WN10-SO-000100.

.NOTES
    Author          : Paul Van Mierlo 
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo 
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000100

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo 
    Systems Tested  : 2025-06-28
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-SO-000100.ps1
#>

# Define registry path and setting
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regName = "RequireSecuritySignature"
$regValue = 1

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create the registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the STIG-required setting
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-SO-000100 remediated: SMB client now requires packet signing."
