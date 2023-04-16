# Duo
Scripts related to Duo.

## Duo Winlogon Upgrader
PowerShell script to upgrade Duo Winlogon

The script does the following:
* checks if Duo Winlogon is installed abort if not found
* checks if Duo Winlogon version is less than 4.2.2 if newer it aborts
* checks if Duo Winlogon is greater than 4.1.0 and aborts if the version is older as manual tweaks are needed. (read more from [Duo here](https://help.duo.com/s/article/1090))
* does not reboot the system even if reboot is needed

Things to note
* Change `newduo` varriable for which version of Duo you want to install.
* Run script as Administrator or System.
* Systems may need an reboot after the upgrade.
