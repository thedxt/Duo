# Duo-Auth-Proxy-Upgrade.ps1
#
# Contributors: @theDXT
# Created: 2026-01-03
# Last Modified: 2026-01-03
# Version 1.0.0
#
# Script URI: https://github.com/thedxt/Duo
#
# Description:
#   This script automates the download and upgrade of the Duo Auth Proxy application.
#   It handles checking if Duo auth Proxy exists, downloading the installer,
#   executing the installation with specified arguments, and cleaning up temporary files post-installation.
# Parameters:
#
#   -TempDir <string>
#       Specifies the directory for temporary files.
#       Default: "C:\Temp"
#
#   -InstallArgs <string>
#       Arguments to pass to the installer for silent installation.
#       Default: "/S"
#
#   -DownloadUrl <string>
#       URL to download the installer from.
#       Default: https://dl.duosecurity.com/duoauthproxy-latest.exe
#
#   -NewVersion <string>
#       The version number of the latest Duo Auth Proxy release.
#       Default: "6.6.0"
#
#   -ProgramName <string>
#       The name of Duo Auth Proxy in Add/Remove Programs
#       Default: "Duo Security Authentication Proxy"
#
# Usage:
#   .\Duo-Auth-Proxy-Upgrade.ps1
#   .\Duo-Auth-Proxy-Upgrade.ps1 -TempDir "D:\CustomTemp"

  [CmdletBinding()]
  param (
      [string]$TempDir = "C:\Temp",
      [string]$InstallArgs = '/S',
      [string]$DownloadUrl = "https://dl.duosecurity.com/duoauthproxy-latest.exe",
      [string]$NewVersion = "6.6.0",
      [string]$ProgramName = "Duo Security Authentication Proxy"
  )

function Duo-Auth-Proxy-Install{

# Duo-Auth-Proxy-Install.ps1
#
# Contributors: @theDXT
# Created: 2026-Jan-03
# Last Modified: 2026-Jan-03
# Version 1.0.0
#
# Script URI: https://github.com/thedxt/Duo
#
# Description:
#   This script automates the download and install of the Duo Auth Proxy application.
#   It handles downloading the installer, executing the installation with specified arguments,
#   and cleaning up temporary files post-installation.
#
# Parameters:
#
#   -TempDir <string>
#       Specifies the directory for temporary files.
#       Default: "C:\Temp"
#
#
#   -InstallArgs <string>
#       Arguments to pass to the installer for silent installation.
#       Default: "/S"
#
#   -DownloadUrl <string>
#       URL to download the installer from.
#       Default: https://dl.duosecurity.com/duoauthproxy-latest.exe
#
# Usage:
#   .\Duo-Auth-Proxy-Install.ps1
#   .\Duo-Auth-Proxy-Install.ps1 -TempDir "D:\CustomTemp"


# Get-Installer.ps1
#
# Function: Get-Installer
#
# Contributors: @kaysouthall, @theDXT
# Created: 2024-Oct-07
# Last Modified: 2025-Dec-19
# Version 2.0.1
#
# Description:
#   Downloads the installer from the specified URL and saves it to the specified output path.
#   Ensures that the temporary directory exists before downloading.
#
# Parameters:
#   - DownloadUrl <string>
#       URL to download the installer from.
#
#   - OutputPath <string>
#       The full path (including filename) to save the downloaded installer.

function Get-Installer {
    param (
        [string]$DownloadUrl,
        [string]$OutputPath
    )
    
    if (-Not (Test-Path -Path $TempDir)) {
        New-Item -ItemType Directory -Path $TempDir | Out-Null
        Write-Host "Created temporary directory: $TempDir"
    }

    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputPath -ErrorAction Stop -UseBasicParsing
        Write-Host "Downloaded installer to: $OutputPath"
    } catch {
        Write-Host "Error downloading installer: $_"
        Exit 1
    }

}

# Install-App.ps1
#
# Function: Install-App
#
# Contributors: @kaysouthall, @theDXT
# Created: 2024-10-07
# Last Modified: 2025-02-27
# Version 3.0.1
#
# Description:
#   Executes the downloaded installer with specified arguments to perform a silent installation.
#
# Parameters:
#   - InstallerPath <string>
#       The full path to the installer file to be executed.

function Install-App {
    param (
        [string]$InstallerPath
    )
    
    try {
    Write-Host "Installation is starting"
       Start-Process $InstallerPath $InstallArgs -wait -WindowStyle Hidden

        Write-Host "Installation completed successfully"
    } catch {
        Write-Host "Error during installation: $_"
        Exit 1
    }
}

# Remove-Installer.ps1
#
# Function: Remove-Installer
#
# Contributors: @kaysouthall
# Created: 2024-10-07
# Last Modified: 2024-10-07
# Version 2.0
#
# Description:
#   Removes the downloaded installer file after installation.
#
# Parameters:
#   - InstallerPath <string>
#       The full path to the installer file to be removed.

function Remove-Installer {
    param (
        [string]$InstallerPath
    )

    try {
        Remove-Item -Path $InstallerPath -ErrorAction Stop
        Write-Host "Cleaned up installer file: $InstallerPath"
    } catch {
        Write-Host "Error cleaning up installer file: $_"
        Exit 1
    }
}

# Main script execution:
#
#
# Contributors: @theDXT
# Created: 2025-Jan-03
# Last Modified: 2025-Jan-03
# Version 1.0.0
#
# 1. Sets the download URL and installer path
# 2. Downloads the installer
# 3. Installs Duo Auth Proxy
# 4. Cleans up the installer file

$InstallerPath = Join-Path $TempDir "DuoAuthProxy.exe"

Write-Host "Starting installation process"
Write-Host "Using download URL: $DownloadUrl"

try {
    Get-Installer -DownloadUrl $DownloadUrl -OutputPath $InstallerPath
    Install-App -InstallerPath $InstallerPath
    
}
catch {
    Write-Host "An error occurred during the installation process: $_"
    Exit 1
}
finally {
    if (Test-Path -Path $InstallerPath) {
        Remove-Installer -InstallerPath $InstallerPath
    } else {
        Write-Host "Installer file not found.  No cleanup necessary."
    }
    Write-Host "Cleanup Completed"
}

Write-Host "Installation process completed"
}
#end of Duo Installer

# Duo-Auth-Proxy-Checker.ps1
#
# Contributors: @theDXT
# Created: 2026-Jan-03
# Last Modified: 2026-Jan-03
# Version 1.0.0
#
# Checks which version of Duo Auth Proxy is installed
#
# Script URI: https://github.com/thedxt/Duo
#

function Duo-Auth-Proxy-Checker {

# function to check the version
function prog-version{
if ($CurentVersion -lt $NewVersion)
{
write-host "$ProgramName is Old"
Duo-Auth-Proxy-Install
}else{
write-host "$ProgramName is current"
}
}
 
# Prog-Finder.ps1
#
# Contributors: @theDXT
# Created: 2023-Apr-16
# Last Modified: 2026-Jan-03
# Version 2.1.0
#
# Looks for a currently installed program.

# Usage:
#   .\Prog-Finder.ps1 -ProgramName "Duo Authentication"

 function prog-finder {
	     param (
		 [Parameter(Mandatory=$true)]
        [string]$ProgramName
    )
 $RegKeys = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -like "*$ProgramName*"}
if ($RegKeys)
{
write-host "$ProgramName is Found"
$CurentVersion = $RegKeys.DisplayVersion
write-host "$ProgramName version is $CurentVersion"
prog-version
}else{
write-host "$ProgramName is NOT Found"
}
}

#run prog-finder
prog-finder -ProgramName $ProgramName

}


# get and store the current progressprefrence setting
$OGProgressPreference = $ProgressPreference

# make downloads go fast
$ProgressPreference = 'SilentlyContinue'

# run everything
Duo-Auth-Proxy-Checker

#set ProgressPreference back to OG setting
$ProgressPreference = $OGProgressPreference
