#include <GuiRichEdit.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <Color.au3>




$path = ""
if FileExists(@ScriptDir & "\minecraft.exe") Then $path = @ScriptDir & "\minecraft.exe"
if FileExists(@AppDataDir & "\.minecraft\minecraft.exe") Then $path = @AppDataDir & "\.minecraft\minecraft.exe"
if $path = "" Then
	MsgBox(0,"Error","Could not find minecraft.exe"&@crlf&"Place in the minecraft folder and run again")
	Exit
EndIf

$MC = Run($path, StringLeft($path, StringInStr($path, "\", -1)), Default, $STDERR_CHILD + $STDOUT_CHILD)
ConsoleWrite("hi"&@CRLF)
$users = ObjCreate("Scripting.Dictionary")
$icolor = ObjCreate("Scripting.Dictionary")
$iColor.add("r", "0x000000")
$icolor.add("0", "0x000000")
$icolor.add("1", "0x0000AA")
$icolor.add("2", "0x00AA00")
$icolor.add("3", "0x00AAAA")
$icolor.add("4", "0xAA0000")
$icolor.add("5", "0xAA00AA")
$icolor.add("6", "0xFFAA00")
$icolor.add("7", "0xAAAAAA")
$icolor.add("8", "0x555555")
$icolor.add("9", "0x5555FF")
$icolor.add("a", "0x55FF55")
$icolor.add("b", "0x55FFFF")
$icolor.add("c", "0xFF5555")
$icolor.add("d", "0xFF55FF")
$icolor.add("e", "0xFFFF55")
$icolor.add("f", "0xFFFFFF")

Local $hGui, $hRichEdit, $iMsg

$hGui = GUICreate("ChatLaunchChat", 320, 350, @DesktopWidth-320, 0)
$hRichEdit = _GUICtrlRichEdit_Create($hGui, "", 10, 10, 300, 330, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
GUISetState()



While 1
    $iMsg = GUIGetMsg()
	Select
		Case $iMsg = $GUI_EVENT_CLOSE
			_GUICtrlRichEdit_Destroy($hRichEdit) ; needed unless script crashes
			Exit
	EndSelect

	$line = StdoutRead($MC)
    If @error Then ExitLoop
    If StringLen($line) > 3 Then
		process($hRichEdit,$line)
	EndIf
WEnd

Func process($hRichEdit,$s)
	$a = StringRegExp($s,".*\[CHAT\] <?([^<>\r\n ]*)\W? (.*)",3)
	If @error then return -1
	ConsoleWrite(1&"	"&"r"&$a[0]&" : "&$a[1]&@CRLF)
	if not $icolor.exists($a[0]) Then
		$icolor.add($a[0],randcolor())
	EndIf
	$s = "r : "&$a[1]
	$a2 = StringRegExp($s, "([\w\*])?(.*?)[§\r]",3)
	If @error or (UBound($a2) < 2) then return -2
	ConsoleWrite(2&"	"&UBound($a2)&"	"&$a[0]&"	"&$iColor.item($a[0])&@crlf)
	_GUICtrlRichEdit_AppendTextColor($hRichEdit, $a[0], $iColor.item($a[0]))
	for $i = 0 to UBound($a2)-1 step 2
		ConsoleWrite($i&"	"&$a2[$i+1]&", "&$iColor.item($a2[$i])&@CRLF)
		_GUICtrlRichEdit_AppendTextColor($hRichEdit, $a2[$i+1], $iColor.item($a2[$i]))
	Next
	_GUICtrlRichEdit_AppendText($hRichEdit,@CR)
EndFunc



Func _GUICtrlRichEdit_AppendTextColor($hWnd, $sText, $iColor)
	Local $iLength = _GUICtrlRichEdit_GetTextLength($hWnd, True, True)
	Local $iCp = _GUICtrlRichEdit_GetCharPosOfNextWord($hWnd, $iLength)
	_GUICtrlRichEdit_AppendText($hWnd, $sText)
	_GUICtrlRichEdit_SetSel($hWnd, $iCp-1, $iLength + StringLen($sText))
	_GUICtrlRichEdit_SetCharColor($hWnd, $iColor)
	_GuiCtrlRichEdit_Deselect($hWnd)
EndFunc

Func randcolor()
	Local $a[3] = [Random(1,240,1), 240, 100], $ret = "0x"
	$a = _ColorConvertHSLtoRGB($a)
	for $i = 0 to 2
		$ret &= Hex(Round($a[$i]),2)
	Next
	Return $ret
EndFunc