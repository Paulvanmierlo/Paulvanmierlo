<#
.SYNOPSIS
    This PowerShell script disables third-party content suggestions in Windows Spotlight for the current user to comply with STIG ID WN10-CC-000390.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-CC-000390

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11
    PowerShell Ver. : 5.1+

.USAGE
    Run as the target user.
    Example:
    PS C:\> .\Remediate-STIG-WN10-CC-000390.ps1
#>

# Registry path and value for current user
$regPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$regName = "DisableThirdPartySuggestions"
$regValue = 1  # 1 = Disable third-party suggestions

# Create registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply registry value
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-CC-000390 remediated: Third-party content suggestions in Windows Spotlight have been disabled for the current user."
