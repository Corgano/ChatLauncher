#include <Constants.au3>

AutoItWinSetTitle("Helper")	;used for the main script to detect it

$MainPID = ""


While Sleep(1000)	;while running (add exit conditions in this loop)

	If WinExists("Mainscript|") Then	;Detect the main script starting. This will only happen if it was started with no cmdline

		;get the path (as part of it's title) of the mainscript and close it
		$title = WinGetTitle("Mainscript|")
		ProcessClose(WinGetProcess($title))

		;get the path of the main script
		$mainPath = StringReplace($title, "Mainscript|", "")
		$mainDir = StringLeft($mainPath, StringInStr($mainPath, "\", 0, -1))
		If StringRight($mainPath, 4) = ".au3" Then $mainPath ='"C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "'&$mainPath&'"'

		;run the main script again, this time as child so we can send it console info
		$MainPID = Run($mainPath&" "&@AutoItPID, $mainDir, Default, $STDIN_CHILD + $STDOUT_CHILD)

		While ProcessExists($MainPID)
			Sleep(1000)

			;code to get useful data here
			StdinWrite($MainPID, "From helper:	"&Random(0,9999999,1) & @CRLF)
			If @error Then
				StdinWrite($MainPID)
				ExitLoop
			EndIf

		WEnd

	EndIf

WEnd
