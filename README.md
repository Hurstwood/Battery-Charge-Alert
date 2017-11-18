# Battery
An AHK (AutoHotKey) script that detects whether the user needs to plug/unplug the charging cable.

- A notification will appear if the battery charge is above 99% telling the user to unplug the charger.
- A notification will appear if the battery charge reachs 10% or below telling the user to plug in the charger.

Both notifications will appear with a short (0.2 second) 1.5khz tone.

The user is able to dismiss the notification. If the user hasn't acted accordingly within 5 seconds, the notification will appear again.


This script definitely works for Windows 10. I'm not sure if it will work for other another OS.


To get this script to work each and every time you start your computer, place the executable in *'..\Microsoft\Windows\Start Menu\Programs\StartUp'*. Open run using *Win+R* and open *'shell:common startup'*.
