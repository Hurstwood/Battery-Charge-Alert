; Battery charge notification
;
; When the battery is charged, a notification
; will appear to tell the user to remove the charger
;
; When the battery is below 10%, a notification
; will appear to tell the user to plug in the charger
;
; Improvements 
; - Allow the user to set both boundaries instead of being fixed. 
;   * Read a config file at start up


SetTitleMatchMode 2
#SingleInstance ignore
#NoTrayIcon

percentage := "%"
sleepTime := 60

Loop{ ;Loop forever

	;Grab the current data.
	VarSetCapacity(powerstatus, 1+1+1+1+4+4)
	success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

	acLineStatus:=ReadInteger(&powerstatus,0)			; Charger connected
	batteryLifePercent:=ReadInteger(&powerstatus,2)		; Battery charge level

	;Is the battery charged higher than 99%
	if (batteryLifePercent > 99){ ; Yes. 

		if (acLineStatus == 1){ ; Only alert if the power lead is connected
			if (batteryLifePercent == 255){		; Battery is disconnected
				sleepTime := 60
			} else{
				
				; Alert user visually and audibly
				output=UNPLUG THE CHARGING CABLE !!!`nBattery Life: %batteryLifePercent%%percentage%
				SoundBeep, 1500, 200
				MsgBox, %output%
				
				sleepTime := 5	; Short delay since the power lead is connected and the message box has been dismissed
			}
		}
		else{
			sleepTime := 60		; Long delay since the battery should take a while to discharge
		}
	}

	;Is the battery charged less than 10%
	if (batteryLifePercent < 10){ ; Yes

		if (acLineStatus == 0){ ; Only alert if the power lead is not connected
			
			; Alert user visually and audibly
			output=PLUG IN THE CHARGING CABLE !!!`nBattery Life: %batteryLifePercent%%percentage%
			SoundBeep, 1500, 200
			MsgBox, %output%
			
			sleepTime := 5		; Short delay since the power lead is not connected and the message box has been dismissed
		} else{
			sleepTime := 60		; Long delay since the battery should take a while to charge
		}
	}


	sleep, sleepTime*1000		; Delay in seconds
}


;Format the data
ReadInteger( p_address, p_offset){
  loop, 1
	value := 0+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
  return, value
}