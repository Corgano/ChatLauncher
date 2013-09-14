#include <GuiRichEdit.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

;when the helper runs it then it's run with the helper's PID
if $CmdLine[0] = 0 Then	;when run by itself

	AutoItWinSetTitle("Mainscript|"&@ScriptFullPath)	;the helper looks for this, and gets the script path from this

	If not WinExists("Helper") Then
		ConsoleWrite("Starting helper..."&@CRLF)
		Run("helper.exe")
	Else
		ConsoleWrite("Waiting for helper"&@CRLF)
	EndIf

	while sleep(100)	;wait for the helper to close it. When the helper
	WEnd

EndIf

;if the helper launches it

Local $hGui, $hRichEdit, $iMsg
$hGui = GUICreate("Example (" & StringTrimRight(@ScriptName, 4) & ")", 320, 350, -1, -1)
$hRichEdit = _GUICtrlRichEdit_Create($hGui, "Command line: "&$CmdLineRaw&@CRLF, 10, 10, 300, 220, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
GUISetState()


While True

	$line = ConsoleRead()
	if StringLen($line) > 3 Then
		_GUICtrlRichEdit_AppendText($hRichEdit, $line)
	EndIf


    $iMsg = GUIGetMsg()
    Select
        Case $iMsg = $GUI_EVENT_CLOSE
            _GUICtrlRichEdit_Destroy($hRichEdit) ; needed unless script crashes
            GUIDelete()     ; is OK too
            Exit
    EndSelect
WEnd

