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
# set the defaults
  [CmdletBinding()]
  param (
      [string]$NewVersion = "6.6.0",
      [string]$ProgramName = "Duo Security Authentication Proxy"
  )

function Duo-Auth-Proxy-Checker {

# function to check the version
function prog-version{
if ($CurentVersion -lt $NewVersion)
{
write-host "$ProgramName is Old"
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

#run it
Duo-Auth-Proxy-Checker
