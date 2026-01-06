# Duo-Win-Logon-Upgrade.ps1
#
# Contributors: @theDXT
# Created: 2026-Jan-05
# Last Modified: 2026-Jan-05
# Version 1.0.0
#
# Script URI: https://github.com/thedxt/Duo
#
# Description:
#   This script automates the download and upgrade of the Duo Win Logon application.
#   It handles checking if Duo Win Logon exists, downloading the installer,
#   executing the installation with specified arguments, and cleaning up temporary files post-installation.
# Parameters:
#
#   -TempDir <string>
#       Specifies the directory for temporary files.
#       Default: "C:\Temp"
#
#   -InstallArgs <string>
#       Arguments to pass to the installer for silent installation.
#       replace IKEY_HERE and SKEY_HERE and API_HOST_HERE with your settings
#
#   -DownloadUrl <string>
#       URL to download the installer from.
#       Default: https://dl.duosecurity.com/duo-win-login-latest.exe
#
#   -NewVersion <string>
#       The version number of the latest Duo Win Logon release.
#       Default: "5.2.1"
#
#   -ProgramName <string>
#       The name of Duo Win Logon in Add/Remove Programs
#       Default: "Duo Authentication for Windows Logon"
#
# Usage:
#   .\Duo-Win-Logon-Upgrade.ps1
#   .\Duo-Win-Logon-Upgrade.ps1 -TempDir "D:\CustomTemp"


# set the defaults
  [CmdletBinding()]
  param (
      [string]$TempDir = "C:\Temp",
      [string]$InstallArgs = '/S /V"REBOOT=ReallySuppress /qn IKEY="IKEY_HERE" SKEY="SKEY_HERE" HOST="API_HOST_HERE" FAILOPEN="#0" RDPONLY="#0""',
      [string]$DownloadUrl = "https://dl.duosecurity.com/duo-win-login-latest.exe",
      [string]$NewVersion = "5.2.1",
      [string]$ProgramName = "Duo Authentication for Windows Logon"
  )

function Duo-Win-Logon-Install{

# Duo-Win-Logon-Install.ps1
#
# Author: Daniel Keer
# Created: 2025-Nov-24
# Last Modified: 2026-Jan-05
# Version 1.0.1
#
# Script URI: https://github.com/thedxt/Duo
#
# Description:
#   This script automates the download and installation of the Duo Win Logon application.
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
#       replace IKEY_HERE and SKEY_HERE and API_HOST_HERE with your settings
#
#   -DownloadUrl <string>
#       URL to download the installer from.
#       Default: https://dl.duosecurity.com/duo-win-login-latest.exe
#
# Usage:
#   .\Duo-Win-Logon-Install.ps1
#   .\Duo-Win-Logon-Install.ps1 -TempDir "D:\CustomTemp"


# Get-Installer.ps1
#
# Function: Get-Installer
#
# Contributors: @kaysouthall, @theDXT
# Created: 2024-Oct-07
# Last Modified: 2026-Jan-04
# Version 2.0.2
#
# Script URI: https://github.com/thedxt/Install-Matrix
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
# Created: 2024-Oct-07
# Last Modified: 2026-Jan-04
# Version 3.0.2
#
# Script URI: https://github.com/thedxt/Install-Matrix
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
# Created: 2024-Oct-07
# Last Modified: 2026-Jan-04
# Version 2.0.1
#
# Script URI: https://github.com/thedxt/Install-Matrix
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
# Created: 2026-Jan-05
# Last Modified: 2026-Jan-03
# Version 1.0.0
#
# 1. Sets the download URL and installer path
# 2. Downloads the installer
# 3. Installs Duo Win Logon
# 4. Cleans up the installer file

$InstallerPath = Join-Path $TempDir "DuoWinLogon.exe"

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

# Duo-Win-Logon-Checker.ps1
#
# Author: Daniel Keer
# Created: 2023-Apr-16
# Last Modified: 2026-Jan-05
# Version 2.0.0
#
# Checks which version of Duo Win Logon is installed
#
# Script URI: https://github.com/thedxt/Duo
#

function Duo-Win-Logon-Checker {  

# function to check the version
function prog-version{
if ($CurentVersion -lt $NewVersion)
{
write-host "$ProgramName is Old"
Duo-Win-Logon-Install
}else{
write-host "$ProgramName is current"
}
}
 
# Prog-Finder.ps1
#
# Contributors: @theDXT
# Created: 2023-Apr-16
# Last Modified: 2026-Jan-04
# Version 2.1.1
#
# Looks for a currently installed program.
#
# Script URI: https://github.com/thedxt/Install-Matrix
#
# Usage:
#   .\Prog-Finder.ps1 -ProgramName "Duo Authentication"

 function Prog-Finder {
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
# run prog-finder
Prog-Finder -ProgramName $ProgramName

}

# get and store the current progressprefrence setting
$OGProgressPreference = $ProgressPreference

# make downloads go fast
$ProgressPreference = 'SilentlyContinue'

# run everything
Duo-Win-Logon-Checker

#set ProgressPreference back to OG setting
$ProgressPreference = $OGProgressPreference
