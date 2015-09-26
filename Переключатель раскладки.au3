; Объявляю главные настройки программы
Global $sFileName        = "Горячие клавиши.txt" ; Имя текстового файла, из которого будут считываться горячие клавиши
Global $sDelimiter       = " "                   ; Разделитель между горячими клавишами и посылаемой комбинацией клавиш
Global $sHotKeyDelimiter = "+"                   ; Разделитель в комбинациях клавиш (Ctrl+Shift+A)

; Объявляю основные переменные
Global $aHotKeys[100][10]
Global $aSendKeys[100][10]
Global $backspace[100] ; сколько раз нажать backspace после переключения раскладки, чтобы убрать символы, оставшиеся после нажатия комбинации
Global $HotKeys[100]



#include <File.au3>
#include <Misc.au3>
#Include <Array.au3>


; Открываю dll, т.к. по рекомендуют при повторном использованеии _IsPressed() передавать обработчик
Global $hDLL = DllOpen("user32.dll")

; Считывает горячие клавиши из текстового файла конфигурации.
Func ReadHotKeys()
   Local $i, $k, $val, $line, $arr[100]
   FileOpen($sFileName, 0)
   For $i = 1 to _FileCountLines($sFileName)
	  $line = FileReadLine($sFileName, $i)
	  $line = StringSplit($line, $sDelimiter, 2)
	  $HotKeys[$i-1] = $line[0]
	  
	  ; Собираю массив горячих клавиш
	  $arr = StringSplit($line[0], $sHotKeyDelimiter, 2)
	  $k = 0
	  for $val In $arr
		 $aHotKeys[$i-1][$k] = ReplaceKey($val)
		 if (StringLen($val) == 1) Then $backspace[$i-1] = $backspace[$i-1] + 1
		 if StringInStr($val, "Ctrl") Then $backspace[$i-1] = -1000
			if StringInStr($val, "Alt") Then $backspace[$i-1] = -1000
		 $k = $k + 1
	  Next
	  
	  ; Собираю массив ответных комбинаций клавиш
	  $arr = StringSplit($line[1], $sHotKeyDelimiter, 2)
	  $k = 0
	  for $val In $arr
		 $aSendKeys[$i-1][$k] = $val
		 $k = $k + 1
	  Next
	  
   Next
   FileClose($sFileName)
EndFunc


Func alert($msg)
   MsgBox(0, "", $msg, 5)
EndFunc


; Проверяет совпадение заданных комбинаций клавиш. Возвращает $i - номер совпавшей комбинации (индекс в массиве), False - если ни одна из комбинаций не совпала
Func CheckCombination($aCombinations)
   Local $combination, $keys1[100], $i, $k, $key, $result
   
   if Not $aCombinations[0][0] Then ; Если не задано комбинаций, значит и не было совпадения
	  Return False
   EndIf
   
   For $i = 0 To UBound($aCombinations, 1) - 1
	  if $aCombinations[$i][0]== "" Then ContinueLoop
	  $result = True
	  For $k = 0 To UBound($aCombinations, 2) - 1
		 $key = $aCombinations[$i][$k]
		 if $key== "" Then ContinueLoop
		 if Not _IsPressed($key, $hDLL) Then ; Проверяю: нажата ли каждая из перечисленных клавиш
			$result = False
		 EndIf
	  Next
	  If $result Then Return $i
   Next
   
   Return False
EndFunc

; Замена названия клавиши на ее 16-ричный код
Func ReplaceKey($sKey)
   if (StringCompare("plus", $sKey) == 0) Then Return "6B"
   if (StringCompare("BACKSPACE", $sKey) == 0) Then Return "08"
   if (StringCompare("TAB", $sKey) == 0) Then Return "09"
   if (StringCompare("CLEAR", $sKey) == 0) Then Return "0C"
   if (StringCompare("ENTER", $sKey) == 0) Then Return "0D"
   if (StringCompare("SHIFT", $sKey) == 0) Then Return "10"
   if (StringCompare("CTRL", $sKey) == 0) Then Return "11"
   if (StringCompare("ALT", $sKey) == 0) Then Return "12"
   if (StringCompare("PAUSE", $sKey) == 0) Then Return "13"
   if (StringCompare("CAPSLOCK", $sKey) == 0) Then Return "14"
   if (StringCompare("ESC", $sKey) == 0) Then Return "1B"
   if (StringCompare("SPACEBAR", $sKey) == 0) Then Return "20"
   if (StringCompare("PAGEUP", $sKey) == 0) Then Return "21"
   if (StringCompare("PAGEDOWN", $sKey) == 0) Then Return "22"
   if (StringCompare("END", $sKey) == 0) Then Return "23"
   if (StringCompare("HOME", $sKey) == 0) Then Return "24"
   if (StringCompare("LEFTARROW", $sKey) == 0) Then Return "25"
   if (StringCompare("UPARROW", $sKey) == 0) Then Return "26"
   if (StringCompare("RIGHTARROW", $sKey) == 0) Then Return "27"
   if (StringCompare("DOWNARROW", $sKey) == 0) Then Return "28"
   if (StringCompare("SELECT", $sKey) == 0) Then Return "29"
   if (StringCompare("PRINT", $sKey) == 0) Then Return "2A"
   if (StringCompare("EXECUTE", $sKey) == 0) Then Return "2B"
   if (StringCompare("PRINTSCREEN", $sKey) == 0) Then Return "2C"
   if (StringCompare("INS", $sKey) == 0) Then Return "2D"
   if (StringCompare("DEL", $sKey) == 0) Then Return "2E"
   if (StringCompare("0", $sKey) == 0) Then Return "30"
   if (StringCompare("1", $sKey) == 0) Then Return "31"
   if (StringCompare("2", $sKey) == 0) Then Return "32"
   if (StringCompare("3", $sKey) == 0) Then Return "33"
   if (StringCompare("4", $sKey) == 0) Then Return "34"
   if (StringCompare("5", $sKey) == 0) Then Return "35"
   if (StringCompare("6", $sKey) == 0) Then Return "36"
   if (StringCompare("7", $sKey) == 0) Then Return "37"
   if (StringCompare("8", $sKey) == 0) Then Return "38"
   if (StringCompare("9", $sKey) == 0) Then Return "39"
   if (StringCompare("A", $sKey) == 0) Then Return "41"
   if (StringCompare("B", $sKey) == 0) Then Return "42"
   if (StringCompare("C", $sKey) == 0) Then Return "43"
   if (StringCompare("D", $sKey) == 0) Then Return "44"
   if (StringCompare("E", $sKey) == 0) Then Return "45"
   if (StringCompare("F", $sKey) == 0) Then Return "46"
   if (StringCompare("G", $sKey) == 0) Then Return "47"
   if (StringCompare("H", $sKey) == 0) Then Return "48"
   if (StringCompare("I", $sKey) == 0) Then Return "49"
   if (StringCompare("J", $sKey) == 0) Then Return "4A"
   if (StringCompare("K", $sKey) == 0) Then Return "4B"
   if (StringCompare("L", $sKey) == 0) Then Return "4C"
   if (StringCompare("M", $sKey) == 0) Then Return "4D"
   if (StringCompare("N", $sKey) == 0) Then Return "4E"
   if (StringCompare("O", $sKey) == 0) Then Return "4F"
   if (StringCompare("P", $sKey) == 0) Then Return "50"
   if (StringCompare("Q", $sKey) == 0) Then Return "51"
   if (StringCompare("R", $sKey) == 0) Then Return "52"
   if (StringCompare("S", $sKey) == 0) Then Return "53"
   if (StringCompare("T", $sKey) == 0) Then Return "54"
   if (StringCompare("U", $sKey) == 0) Then Return "55"
   if (StringCompare("V", $sKey) == 0) Then Return "56"
   if (StringCompare("W", $sKey) == 0) Then Return "57"
   if (StringCompare("X", $sKey) == 0) Then Return "58"
   if (StringCompare("Y", $sKey) == 0) Then Return "59"
   if (StringCompare("Z", $sKey) == 0) Then Return "5A"
   if (StringCompare("LeftWindows", $sKey) == 0) Then Return "5B"
   if (StringCompare("RightWindows", $sKey) == 0) Then Return "5C"
   if (StringCompare("Numericpad0", $sKey) == 0) Then Return "60"
   if (StringCompare("Numericpad1", $sKey) == 0) Then Return "61"
   if (StringCompare("Numericpad2", $sKey) == 0) Then Return "62"
   if (StringCompare("Numericpad3", $sKey) == 0) Then Return "63"
   if (StringCompare("Numericpad4", $sKey) == 0) Then Return "64"
   if (StringCompare("Numericpad5", $sKey) == 0) Then Return "65"
   if (StringCompare("Numericpad6", $sKey) == 0) Then Return "66"
   if (StringCompare("Numericpad7", $sKey) == 0) Then Return "67"
   if (StringCompare("Numericpad8", $sKey) == 0) Then Return "68"
   if (StringCompare("Numericpad9", $sKey) == 0) Then Return "69"
   if (StringCompare("Multiply", $sKey) == 0) Then Return "6A"
   if (StringCompare("Add", $sKey) == 0) Then Return "6B"
   if (StringCompare("Separator", $sKey) == 0) Then Return "6C"
   if (StringCompare("Subtract", $sKey) == 0) Then Return "6D"
   if (StringCompare("Decimal", $sKey) == 0) Then Return "6E"
   if (StringCompare("Divide", $sKey) == 0) Then Return "6F"
   if (StringCompare("F1", $sKey) == 0) Then Return "70"
   if (StringCompare("F2", $sKey) == 0) Then Return "71"
   if (StringCompare("F3", $sKey) == 0) Then Return "72"
   if (StringCompare("F4", $sKey) == 0) Then Return "73"
   if (StringCompare("F5", $sKey) == 0) Then Return "74"
   if (StringCompare("F6", $sKey) == 0) Then Return "75"
   if (StringCompare("F7", $sKey) == 0) Then Return "76"
   if (StringCompare("F8", $sKey) == 0) Then Return "77"
   if (StringCompare("F9", $sKey) == 0) Then Return "78"
   if (StringCompare("F10", $sKey) == 0) Then Return "79"
   if (StringCompare("F11", $sKey) == 0) Then Return "7A"
   if (StringCompare("F12", $sKey) == 0) Then Return "7B"
   Return $sKey
EndFunc


Func SendDecoder($aKeys, $i)
   local $k, $s="", $sEnd="", $key=""
   
   For $k=0 To UBound($aKeys, 2) - 1
	  $key = StringLower($aKeys[$i][$k])
	  
	  If ($key == "") Then
		 ContinueLoop
	  EndIf
	  
	  if (StringInStr($key, "Ctrl")) Then
		 $s = $s & "{"&$key&"Down}"
		 $sEnd = "{"&$key&"Up}" & $sEnd
	  ElseIf (StringInStr($key, "Shift")) Then
		 $s = $s & "{"&$key&"Down}"
		 $sEnd = "{"&$key&"Up}" & $sEnd
	  ElseIf (StringInStr($key, "Alt")) Then
		 $s = $s & "{"&$key&"Down}"
		 $sEnd = "{"&$key&"Up}" & $sEnd
	  ElseIf (StringInStr($key, "Win")) Then
		 $s = $s & "{"&$key&" Down}"
		 $sEnd = "{"&$key&" Up}" & $sEnd
	  ElseIf (StringInStr($key, "capslock")) Then
		 $s = $s & "{"&$key&" Down}"
		 $sEnd = "{"&$key&" Up}" & $sEnd
	  ElseIf (StringInStr($key, "tab")) Then
		 $s = $s & "{"&$key&" Down}"
		 $sEnd = "{"&$key&" Up}" & $sEnd
	  Else
		 $s = $s & "{"&$key&"}"
	  EndIf
	  
   Next
   
   $s = $s & $sEnd
   
   Return $s
EndFunc



; Главная функция программы

ReadHotKeys()
Local $i
Global $keyReleased = True
While 1
   $i = CheckCombination($aHotKeys)
   if ($i>0 or $i == 0) And $keyReleased Then
	  Send(SendDecoder($aSendKeys, $i))
	  if $backspace[$i] > 0 Then Send("{backspace "&$backspace[$i]&"}")
	  $keyReleased = False
	  TrayTip ( "", "", 10)
	  TrayTip("Горячая клавиша:", $HotKeys[$i], 1)
	  Sleep(300)
	  TrayTip ( "", "", 1)
	  
   Else
	  if Not $keyReleased Then
		 $keyReleased = True
	  EndIf
   EndIf
   
   
   
   Sleep(1)
WEnd

DllClose($hDLL)


