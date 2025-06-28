<#
.SYNOPSIS
    This PowerShell script disables Internet Explorer 11 as a standalone browser via registry to comply with STIG ID WN10-CC-000391.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.2
    STIG-ID         : WN10-CC-000391

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  :In progress
    PowerShell Ver. : 5.1+

.USAGE
    Run as Administrator.
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"

# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "You must run this script as Administrator!"
    exit 1
}

# Create the registry path if needed
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Disable IE11 as standalone browser
New-ItemProperty -Path $regPath -Name "DisableIE" -PropertyType DWord -Value 1 -Force | Out-Null

# Also apply the newer policy version if needed
$regPathPolicyOption = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"
New-ItemProperty -Path $regPathPolicyOption -Name "DisableIEOptions" -PropertyType DWord -Value 1 -Force | Out-Null

Write-Output "✅ STIG WN10-CC-000391 remediated: Internet Explorer 11 is disabled via registry policy."
