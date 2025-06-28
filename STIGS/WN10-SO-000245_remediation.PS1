<#
.SYNOPSIS
    This PowerShell script enables Admin Approval Mode for the built-in Administrator account to comply with STIG ID WN10-SO-000245.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-SO-000245

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11
    PowerShell Ver. : 5.1+

.USAGE
    Run as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-SO-000245.ps1
#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "FilterAdministratorToken"
$regValue = 1  # Enable Admin Approval Mode for built-in Administrator account

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

# Apply the registry value
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-SO-000245 remediated: Admin Approval Mode for the built-in Administrator is now enabled."
