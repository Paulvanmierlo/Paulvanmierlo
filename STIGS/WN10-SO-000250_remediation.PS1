<#
.SYNOPSIS
    This PowerShell script sets UAC to prompt administrators for consent on the secure desktop, to comply with STIG ID WN10-SO-000250.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-SO-000250

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-SO-000250.ps1
#>

# Registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "ConsentPromptBehaviorAdmin"
$regValue = 2  # Prompt for consent on the secure desktop

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create registry path if needed
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the required setting
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-SO-000250 remediated: UAC is now set to prompt admins on the secure desktop."
