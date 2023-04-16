# Duo Winlogon Upgrader
# Author: Daniel Keer
# Author URI: https://thedxt.ca
# Script URI: https://github.com/thedxt/Duo

# the url for the download
$DLURL = "https://dl.duosecurity.com/DuoWinLogon_MSIs_Policies_and_Documentation-latest.zip"

# the temp folder name for the download and the install to run from
$temp = "temp"

# the nice name of the item you are downloading
$name = "Duo Windows Logon and RDP"


#zip name
$zip = "DuoWinLogon_MSIs"

#current duo version
$newduo = "4.2.2"

# function to check if temp exists if not make it

function temp-check{

if (-not (Test-Path $Env:SystemDrive\$temp))
{
New-Item -ItemType Directory $Env:SystemDrive\$temp | out-null
}

}

# function do the download
function Download{

# enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-host "Downloading $name"
temp-check
# Download it
Invoke-WebRequest -Uri $DLURL -OutFile "$Env:SystemDrive\$temp\$zip.zip"
Write-host "$name zip is downloaded"
}

# function to extract the zip
function Extract{
Write-host "Extracting $name zip"
Expand-Archive -force "$Env:SystemDrive\$temp\$zip.zip" -DestinationPath $Env:SystemDrive\$temp\$zip
Write-host "$name zip is extracted"
}

# function to run the MSI upgrade
function Duo-Upgrade-Install{
Write-host "Upgrading $name"

Start-Process msiexec.exe -Wait -ArgumentList "/i", "$Env:SystemDrive\$temp\$zip\DuoWindowsLogon64.msi", "/qn", "/norestart"  -WindowStyle Hidden


Write-host "$name Should now be Upgraded"
}

# function to check the version and upgrade
# Versions older than 4.1.0 need manual work to upgrade
function duo-version{
if (($duoVersion -lt $newduo)-and($duoVersion -gt "4.1.0"))
{
write-host "Duo Version is Old"
temp-check
download
Extract
Duo-Upgrade-Install
}else{
write-host "Duo version is current"
}
}
 
# function to check for duo then run the version check then do the upgrade if found and is old
 function duo-checker {
 $DuoRegCheck = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -like 'Duo Authentication for Windows Logon*'}
if ($DuoRegCheck)
{
write-host "Duo is Found"
$duoVersion = $DuoRegCheck.DisplayVersion
write-host $duoVersion
duo-version


}else{
write-host "Duo is NOT Found"
}
}
# run everything
duo-checker
