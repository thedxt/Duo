# Duo
Scripts related to Duo.

#

## Duo _Winlogon_Upgrader.ps1
PowerShell script to upgrade Duo Winlogon

The script does the following:
* checks if Duo Winlogon is installed abort if not found
* checks if Duo Winlogon version is less than 4.2.2 if newer it aborts
* checks if Duo Winlogon is greater than 4.1.0 and aborts if the version is older as manual tweaks are needed. (read more from [Duo here](https://help.duo.com/s/article/1090))
* does not reboot the system even if reboot is needed

Things to note
* Change `newduo` variable for which version of Duo you want to install.
* Run script as Administrator or System.
* Systems may need an reboot after the upgrade.

## Duo-Auth-Proxy-Checker.ps1
PowerShell script to check the version of Duo Auth Proxy

The script does the following:
* Checks if Duo Auth Proxy is installed by using the `Prog-Finder.ps1` script from [Intall-Matrix](https://github.com/thedxt/Install-Matrix/) repo.
* Checks if Duo Auth Proxy is less than or greater than 6.6.0 and reports the findings
  * You can edit the script to detect newer versions by editing the `NewVersion` variable

## Duo-Auth-Proxy-Install.ps1
PowerShell script to Install the latest version of Duo Auth Proxy

The script does the following:
* Installs the latest version of Duo Auth Proxy using various functions from [Intall-Matrix](https://github.com/thedxt/Install-Matrix/) repo.
  * Checks if temp folder exists or not and creates it if needed.
  * Stores the current value of `$ProgressPreference` then sets it to `SilentlyContinue` to speed up headless downloads.
  * Downloads Duo Auth Proxy to the temp folder and uses an always current URL from Duo for the download.
  * Installs Duo Auth Proxy silently.
  * Removes the downloaded Duo Auth Proxy file from the temp folder.
  * Sets the value of `$ProgressPreference` to the original value.
