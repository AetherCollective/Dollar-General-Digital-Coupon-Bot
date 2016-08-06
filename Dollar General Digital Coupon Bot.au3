#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\ISN AutoIt Studio\autoitstudioicon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include "Includes\ImageSearch.au3"
#include <GDIPlus.au3>
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
_Singleton("DGDCB")
Global $path = @TempDir & "\BetaLeaf Software\Dollar General Digital Coupon Bot"
Global $wintitle = "Dollar General Digital Coupon Bot"
FileInstall("Includes\ImageSearchDLL.dll", $path & "\ImageSearchDLL.dll", 1)
FileInstall("Includes\ImageSearch.au3", $path & "\ImageSearch.au3", 1)
FileInstall("Images\Click.png", $path & "\Click.png", 1)
_GDIPlus_Startup()
OnAutoItExitRegister("_Exit")
Global $iX, $iY,$Count
ProcessSetPriority(@ScriptName, 3)
ProcessSetPriority("AutoIt3.exe", 3)
Opt("MouseCoordMode", 1)
Opt("PixelCoordMode", 2)
Opt("TrayIconDebug", 1)
Opt("WinTitleMatchMode", 2)
;Opt("MouseClickDelay", 30)
;Opt("MouseClickDownDelay", 30)
DirCreate($path)
FileChangeDir($path)
If Not WinExists("Coupons Gallery") Then
	If ShellExecute("https://dg.coupons.com/coupons/") = 0 Then MsgBox(16, $wintitle, "Could not open browser to dg.coupons.com/coupons" & @CRLF & "Please open your browser to this url before continuing.")
	Sleep(3000)
EndIf
Global $hwnd = WinWait("Coupons Gallery")
Global $hwndpos = WinGetPos($hwnd)
Global $iLeft = $hwndpos[0]
Global $iTop = $hwndpos[1]
Global $iRight = $hwndpos[2] + $hwndpos[0]
Global $iBottom = $hwndpos[3] + $hwndpos[1]
MsgBox(64, $wintitle, "Make sure you are logged in, then press ok.")
sleep(100)
WinActivate("Coupons Gallery")
For $i= 1 to 100
Send("{end}")
sleep(100)
Next
Send("{home}")
Do
	If _FindImage() = 0 Then ;if failed
		$Count += 1 ;increase count
	Else
		sleep(100)
		$Count = 0
	EndIf
	If $Count > 2 Then
		Send("{pgdn}") ;if count exceeds 2 then page down
		Sleep(500)
	EndIf
	ConsoleWrite("Count = "&$Count&@crlf)
Until $Count > 30
MsgBox(0, $wintitle, "Done.")
Func _FindImage() ;the function that searches
	Global $hImage = _GDIPlus_ImageLoadFromFile($path & "\Click.png")
	Global $hHBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	Local $iRet = _ImageSearchArea($hHBmp, 1, $iLeft, $iTop, $iRight, $iBottom, $iX, $iY, 5, 0)
	_WinAPI_DeleteObject($hHBmp)
	_GDIPlus_ImageDispose($hImage)
	If $iRet = 1 Then
		ConsoleWrite("Found Image!"&@crlf)
		MouseClick("", $iX, $iY, 1, 0)
		MouseMove(0, 0, 0)
		Return 1
	Else
		ConsoleWrite("Did not find image."&@crlf)
		Return 0
	EndIf
EndFunc   ;==>_FindImage
Func GetWin()
	$hwndpos = WinGetPos("Coupons Gallery")
	$iLeft = $hwndpos[0]
	$iTop = $hwndpos[1]
	$iRight = $hwndpos[2] + $hwndpos[0]
	$iBottom = $hwndpos[3] + $hwndpos[1]
EndFunc   ;==>GetWin
Func _Exit()
	_GDIPlus_Shutdown()
EndFunc   ;==>_Exit