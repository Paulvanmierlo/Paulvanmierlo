<#
.SYNOPSIS
    This PowerShell script enables Kernel DMA Protection by setting the device enumeration policy to "Block All", complying with STIG ID WN10-EP-000310.

.NOTES
    Author          : Paul Van Mierlo
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    STIG-ID         : WN10-EP-000310

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo
    Systems Tested  : Windows 10 (v1803+) and Windows 11
    PowerShell Ver. : 5.1+

.USAGE
    Run as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-EP-000310.ps1
#>

# Define the registry path and setting
$regPath = "HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection"
$regName = "DeviceEnumerationPolicy"
$regValue = 0  # 0 = Block all incompatible devices (enables protection)

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create the key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting
New-ItemProperty -Path $regPath -Name $regName -PropertyType DWord -Value $regValue -Force | Out-Null

Write-Output "✅ STIG WN10-EP-000310 remediated: Kernel DMA Protection enabled (DeviceEnumerationPolicy set to 0)."
