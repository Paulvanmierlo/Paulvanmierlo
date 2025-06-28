<#
.SYNOPSIS
    This PowerShell script prevents Windows apps from being activated by voice while the system is locked, complying with STIG ID WN10-CC-000365.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-CC-000365

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11 (v1903+)
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-CC-000365.ps1
#>

# Registry path and values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
$voiceLockValueName = "LetAppsActivateWithVoiceAboveLock"
$voiceValueName = "LetAppsActivateWithVoice"
$regValue = 2  # Force Deny

# Ensure the script runs with admin privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply both values
New-ItemProperty -Path $regPath -Name $voiceLockValueName -PropertyType DWord -Value $regValue -Force | Out-Null
New-ItemProperty -Path $regPath -Name $voiceValueName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-CC-000365 remediated: Voice activation while system is locked has been disabled."
