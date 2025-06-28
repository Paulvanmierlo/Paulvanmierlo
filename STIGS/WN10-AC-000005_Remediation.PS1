<# 
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Paul Van Mierlo 
    LinkedIn        : linkedin.com/in/paulgvm/
    GitHub          : github.com/PaulVanMierlo 
    Date Created    : 2025-06-28
    Last Modified   : 2025-06-28
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 

.TESTED ON
    Date(s) Tested  : 2025-06-28
    Tested By       : Paul Van Mierlo 
    Systems Tested  : In progress
    PowerShell Ver. : 2025-06-28

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>
# Ensure script is run as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You must run this script as Administrator!"
    exit 1
}

# Set Account Lockout Duration to 15 minutes
Start-Process -FilePath "net" -ArgumentList "accounts /lockoutduration:15" -Wait -NoNewWindow

# Set Lockout Threshold to 5 attempts
Start-Process -FilePath "net" -ArgumentList "accounts /lockoutthreshold:5" -Wait -NoNewWindow

# Set Lockout Observation Window to 15 minutes
Start-Process -FilePath "net" -ArgumentList "accounts /lockoutwindow:15" -Wait -NoNewWindow

# Display current settings to confirm
Start-Sleep -Seconds 2
net accounts

Write-Host "`n✅ Account Lockout Policy has been configured to meet STIG WN10-AC-000005 requirements." -ForegroundColor Green
