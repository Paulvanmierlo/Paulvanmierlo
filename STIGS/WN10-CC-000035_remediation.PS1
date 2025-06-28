<#
.SYNOPSIS
    This PowerShell script configures the system to ignore NetBIOS name release requests except from WINS servers, to comply with STIG ID WN10-CC-000035.

.NOTES
    Author          : Paul Van Mierlo 
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo 
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000035

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo 
    Systems Tested  : In progress
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-CC-000035.ps1
#>

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters"
$regName = "NoNameReleaseOnDemand"
$regValue = 1

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create the registry path if needed
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the registry value
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-CC-000035 remediated: System will now ignore NetBIOS name release requests except from WINS servers."
