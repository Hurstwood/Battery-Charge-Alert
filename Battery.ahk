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
sleepTime := 60 * 1000 ; Delay in seconds

Loop{ ;Loop forever

	;Grab the current data.
	;https://docs.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-system_power_status
	VarSetCapacity(powerstatus, 12) ;1+1+1+1+4+4
	success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

	acLineStatus:=ExtractValue(&powerstatus,0)			; Charger connected
	batteryChargePercent:=ExtractValue(&powerstatus,2)		; Battery charge level

	;Is the battery charged higher than 99%
	if (batteryChargePercent > 99){ ; Yes. 

		if (acLineStatus == 1){ ; Only alert if the power lead is connected
			if (batteryChargePercent != 255){		; and if the battery is not disconnected
			
				output=UNPLUG THE CHARGING CABLE !!!`nBattery Charge Level: %batteryChargePercent%%percentage%
				notifyUser(output)
			}
		}
	}

	;Is the battery charged less than 10%
	if (batteryChargePercent < 10){ ; Yes

		if (acLineStatus == 0){ ; Only alert if the power lead is not connected
			
			output=PLUG IN THE CHARGING CABLE !!!`nBattery Charge Level: %batteryChargePercent%%percentage%
			notifyUser(output)
		}
	}


	sleep, sleepTime		
}


; Alert user visually and audibly
notifyUser(message){
	SoundBeep, 1500, 200
	MsgBox, %message%
}


;Format the value from the structure
ExtractValue( p_address, p_offset){
  loop, 1
	value := 0+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
  return, value
}