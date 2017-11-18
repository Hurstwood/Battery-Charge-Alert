; Battery notification
;
; When the battery is charged, a notification
; will appear to tell the user to remove the charger
;
; When the battery is below 10%, a notification
; will appear to tell the user to plug in the charger


SetTitleMatchMode 2
#SingleInstance ignore
#NoTrayIcon

percentage := "%"
sleepTime := 60

Loop{ ;Loop forever

;Grab the current data.
VarSetCapacity(powerstatus, 1+1+1+1+4+4)
success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

acLineStatus:=ReadInteger(&powerstatus,0)
batteryLifePercent:=ReadInteger(&powerstatus,2)

;Is the battery charged higher than 99%
if (batteryLifePercent > 99){ ;Yes. 

	if (acLineStatus == 1){ ;Only notify me once
		if (batteryLifePercent == 255){
			sleepTime := 60
			}
		else{
			;Format the message box
			output=UNPLUG THE CHARGING CABLE !!!`nBattery Life: %batteryLifePercent%%percentage%
			SoundBeep, 1500, 200
			MsgBox, %output% ;Notify me.
			sleepTime := 5
		}
	}
	else{
		sleepTime := 60
	}
}

;Is the battery charged higher than 99%
if (batteryLifePercent < 10){ ;Yes. 

	if (acLineStatus == 0){ ;Only notify me once
		;Format the message box
		output=PLUG IN THE CHARGING CABLE !!!`nBattery Life: %batteryLifePercent%%percentage%
		SoundBeep, 1500, 200
		MsgBox, %output% ;Notify me.
		sleepTime := 5
	}
	else{
		sleepTime := 60
	}
}


sleep, sleepTime*1000 ;sleep for 5 seconds
}

;Format the data
ReadInteger( p_address, p_offset)
{
  loop, 1
	value := 0+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
  return, value
}