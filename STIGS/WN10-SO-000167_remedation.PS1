<#
.SYNOPSIS
    This PowerShell script restricts remote access to the Security Account Manager (SAM) to Administrators only, to comply with STIG ID WN10-SO-000167.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-SO-000167

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10/11
    PowerShell Ver. : 5.1+

.USAGE
    Run as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-SO-000167.ps1
#>

# Define the registry path and secure value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regName = "RestrictRemoteSAM"
$regValue = "O:BAG:BAD:(A;;RC;;;BA)"  # Allow Remote Call to SAM by Built-in Administrators only

# Check for admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator."
    exit 1
}

# Create the path if needed
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the secure setting
New-ItemProperty -Path $regPath -Name $regName -PropertyType String -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-SO-000167 remediated: Remote access to SAM restricted to Administrators only."
