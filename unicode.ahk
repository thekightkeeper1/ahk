#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; SETUP GUI
; ==============================================================================
; Create the GUI object but don't show it yet.
; -Caption: Removes title bar/borders for a clean look
; +AlwaysOnTop: Keeps it visible above other windows
; +ToolWindow: Hides it from Alt-Tab menu
U_Gui := Gui("-Caption +AlwaysOnTop +ToolWindow +Border", "Unicode Entry")
U_Gui.SetFont("s14", "Segoe UI")
U_Gui.BackColor := "1d1d1d" ; Dark background
U_Gui.Color := "1d1d1d"

; Add the text box
; cWhite: White text
; Center: Center text alignment
U_Edit := U_Gui.Add("Edit", "w150 h35 cWhite Background333333 Center -E0x200")
; Trigger Submit automatically when 4 characters are typed
U_Edit.OnEvent("Change", (*) => StrLen(U_Edit.Value) = 4 && SubmitHex())

; Variable to store the ID of the window you were working in
global PreviousWindow := 0

; ==============================================================================
; TRIGGER
; ==============================================================================
; :?*: implies:
; ? = Works even if inside another word
; * = Fires immediately without waiting for an end key
; \u = The trigger string
:?*:\u::
{
    Send "{Backspace}"
    global PreviousWindow := WinExist("A") ; Store the handle of the active window
    U_Edit.Value := ""                     ; Clear previous text
    U_Gui.Show("AutoSize Center")          ; Show and activate window
}



; ==============================================================================
; GUI LOGIC (HOTKEYS ACTIVE ONLY WHEN GUI IS OPEN)
; ==============================================================================
#HotIf WinActive(U_Gui.Hwnd)

; Trigger on Enter or Space
Enter::
Space::
{
    SubmitHex()
}

; Cancel on Escape
Esc::
{
    U_Gui.Hide()
    if (PreviousWindow)
        WinActivate(PreviousWindow)
}

#HotIf

; ==============================================================================
; FUNCTIONS
; ==============================================================================
SubmitHex()
{
    inputHex := U_Edit.Value
    
    ; Regex Explanation:
    ; ^           Start of string
    ; [0-9a-fA-F] Valid Hex characters (0-9, a-f)
    ; {1,6}       Between 1 and 6 characters long (covers standard and emoji unicode)
    ; $           End of string
    if RegExMatch(inputHex, "^[0-9a-fA-F]{1,6}$")
    {
        U_Gui.Hide()
        
        if (PreviousWindow && WinExist(PreviousWindow))
        {
            WinActivate(PreviousWindow) ; Switch back to original window
            WinWaitActive(PreviousWindow) ; Wait briefly to ensure it's active
            
            ; Send the unicode character
            Send("{U+" . inputHex . "}")
        }
    }
    else
    {
        ; Optional: Flash the box or play sound if invalid hex
        SoundBeep(200, 100) 
    }
}
