<#
.SYNOPSIS
    This PowerShell script enables PowerShell transcription logging to comply with STIG ID WN10-CC-000327.

.NOTES
    Author          : Paul Van Mierlo 
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo 
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000327

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo 
    Systems Tested  : In progress
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Remediate-STIG-WN10-CC-000327.ps1
#>

# Define registry path and settings
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$enableName = "EnableTranscripting"
$directoryName = "OutputDirectory"

# Set the output directory for transcripts — change this to your secured central log location
$transcriptPath = "C:\Transcripts"  # <-- You should modify this to a secured network share

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting..."
    exit 1
}

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Enable PowerShell transcription
New-ItemProperty -Path $regPath -Name $enableName -PropertyType DWord -Value 1 -Force | Out-Null

# Set the output directory
New-ItemProperty -Path $regPath -Name $directoryName -PropertyType String -Value $transcriptPath -Force | Out-Null

Write-Output "✅ STIG WN10-CC-000327 remediated: PowerShell transcription enabled. Output directory: $transcriptPath"
