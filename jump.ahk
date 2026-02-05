#SingleInstance Force
; SendMode("Event")
; ; SetKeyDelay(0, 50)
; cooldown := false
; #HotIf WinActive("Roblox")
; *XButton2:: {
;     global cooldown 
;     if cooldown
;         return
;     cooldown := true
;     SetTimer(() => cooldown := false, -1100) 
;     Send "{Space}{w down}{Shift down}"
;     Sleep(100)
;     Send "x"
; }
*XButton2::x
; #HotIf WinActive("voices of the void")
; *XButton1::e
; #HotIf WinActive("voices of the void")
*F13::x
