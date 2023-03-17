#Persistent
#NoTrayIcon
#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#Include <Json>
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
InfoText =
(

   writte by

   ██████╗ ███╗   ██╗██╗  ██╗██████╗ ██████╗ ██████╗  ██████╗ ██╗   ██╗
   ██╔══██╗████╗  ██║██║ ██╔╝╚════██╗██╔══██╗██╔══██╗██╔═══██╗╚██╗ ██╔╝
   ██████╔╝██╔██╗ ██║█████╔╝  █████╔╝██████╔╝██████╔╝██║   ██║ ╚████╔╝
   ██╔══██╗██║╚██╗██║██╔═██╗  ╚═══██╗██╔══██╗██╔══██╗██║   ██║  ╚██╔╝
   ██████╔╝██║ ╚████║██║  ██╗██████╔╝██║  ██║██████╔╝╚██████╔╝   ██║
   ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝

   on November 2👽22                                                 
)
Global AppName := "ReadyxChalloBingBong"
Global pgGitHub := "https://bnk3r-boy.github.io/" . AppName . "/"
Global dlGitHub := "https://github.com/BNK3R-Boy/ReadyxChalloBingBong/raw/main/ReadyxChalloBingBong.exe"
Global AppVersion := 20230317040749
Global AppTooltip := AppName
Global TF := A_Temp . "\" . AppName . "\"
Global DEV := !A_Iscompiled
Global ICOFileName := AppName . ".png"
Global ICO := TF . ICOFileName
Global nICO := TF . "n" . ICOFileName
Global menuICO := TF . "larrow.png"
Global exitICO := TF . "exit.png"
Global PathToSplashImage := TF . "splash.png"
Global HistoryFile := TF . "history.txt"
Global SplashPIC_widget_h := 200
Global SplashPIC_widget_w := 463
Global fnSplashTimeout := Func("App_SplashTimeout")
Global fnOpenLink := Func("Menu_OpenLink")
Global ReadedPosting := Array()
Global Sources := Array()
Global SRow := ["Twitch", "Instagram", "YouTube", "Twitter", "TikTok"]
Global Partner := Array()
Global Voice
Global ToolTipToken := True
Global MENUTITELNAMEchannels := "Kanäle"
global MENUTITELNAMEnews := "Neueste Beiträge:"
Global ROSSUB := "Menü"
Global VOICEMENU := "Sprachausgabe"
Global RUNONSTARTUP := "Autostart"
Global UNTAGNEWPOST := "neue Beiträge Markierung entfernen"
Global UPDATEBUTTONTITLE := "Auf App Update prüfen"
Global REFRESHDATAMENU := "Auf neue Beiträge prüfen"
Global MBL := 5
Global TWITCHADD := 2
Global HISTORYLENGTH := 5
Global fnMainProcess := Func("App_MainProcess")
FileEncoding, UTF-8

App_Inizial()
Return

App_AddPartner(pStr, url, ico, stat = True) {
	Static p
	p++
	Partner[p] := []
	Partner[p]["partner"] := pStr
	Partner[p]["url"] := url
	Partner[p]["ico"] := ico
	Partner[p]["status"] := stat
}

App_UpdateSource() {
	while true {
		Try {
			jstr := Str_GetWebData("https://raw.githubusercontent.com/BNK3R-Boy/ReadyxChalloBingBong/main/ChalloBingBong.json")
			jsondata := JSON.Load(jstr)
			i := 0
			For k In jsondata {
				i++
				If !Sources[k]["name"]
					Sources[k] := Array()
				Sources[k]["title"] := StrReplace(Trim(Menu_GetShortMenuTitle(jsondata[k]["title"], MBL+i)), "`n", " ")
				Sources[k]["url"] := jsondata[k]["url"]
				Sources[k]["name"] := jsondata[k]["name"]
				Sources[k]["channelurl"] := jsondata[k]["channel"]
				If (k == "Twitch") And (Sources[k]["title"] == "off")
					Sources[k]["title"] := "Stream Offline"
			}
			Break
		} Catch e {
			Sleep, 333
			Continue
		}
	}
}

App_CheckUpdate(m = 0) {
	uurl := "https://raw.githubusercontent.com/BNK3R-Boy/" . AppName . "/main/version"
	Loop, 3 {
		Try nv := Str_GetWebData(uurl)
		If nv
			Break
	}
	If (InStr(nv, "Not Found")) {
		App_SplashTimeout()
		MsgBox,, %AppName% - Prüfung auf Update gescheitert, %nv%
		Return
	} Else If nv && (nv > AppVersion) {
		App_SplashTimeout()
        MsgBox, 4, %AppName% - Ein neues Update ist verfügbar, %AppVersion% aktuelle Version`n%nv% neue Version`n`nVon Github donwloaden und ReadyxChalloBingbong schließen?
		IfMsgBox Yes
		{
		    Menu_OpenLink("", "", "", dlGitHub)
		    ExitApp
		}
		Return
	}
	If (m) {
		App_SplashTimeout()
        MsgBox,, %AppName% - Prüfung auf Update Abgeschlossen, Kein Update verfügbar.
	}
}

App_Inizial() {
	App_TempSetup()
	(!DEV) ? App_SplashScreen()
	App_CheckUpdate()
	App_UpdateSource()
	; App_AddPartner(p, url, status)
	App_AddPartner("Instant-Gaming", "https://www.instant-gaming.com/?igr=Readyx", "IG.png", True)
	FileInstall, IG.png, %TF%IG.png, 1
	App_AddPartner("Just Legends", "https://justlegends.link/Readyx-Twitch-Panel", "JL.png", True)
	FileInstall, JL.png, %TF%JL.png, 1
	App_AddPartner("StreamerMerch", "https://www.streamermerch.de/readyx", "ST.png", True)
	FileInstall, ST.png, %TF%ST.png, 1
	; App_AddSource(streamer, platform, channel, rss, status)
	FileInstall, Twitch.png, %TF%Twitch.png, 1
	FileInstall, nTwitch.png, %TF%nTwitch.png, 1
	FileInstall, YouTube.png, %TF%YouTube.png, 1
	FileInstall, nYouTube.png, %TF%nYouTube.png, 1
	FileInstall, Instagram.png, %TF%Instagram.png, 1
	FileInstall, nInstagram.png, %TF%nInstagram.png, 1
	FileInstall, Twitter.png, %TF%Twitter.png, 1
	FileInstall, nTwitter.png, %TF%nTwitter.png, 1
	FileInstall, Tiktok.png, %TF%Tiktok.png, 1
	FileInstall, nTiktok.png, %TF%nTiktok.png, 1
	FileInstall, larrow.png, %TF%larrow.png, 1
	FileInstall, exit.png, %TF%exit.png, 1
	(DEV) ? Menu, Tray, Icon
	Menu_Setup()
	Menu_UpdateMenuCheckmarks()
	Tray_CheckNewPostings()
	App_MainProcess(1)
	Menu, Tray, Icon
	App_SplashTimeout()
	
	If FileExist("html.html")
		FileDelete, html.html
}

App_IsOnline() {
	RunWait, %ComSpec% /c ping -n 1 1.1.1.1 ,, Hide UseErrorLevel
	Return !ErrorLevel
}

App_MainProcess(Opt = 0) {
	Static a, OptRem
	ONLINE := App_IsOnline()
	If ONLINE {
		StartTime := A_TickCount
		Try {
			jstr := Str_GetWebData("https://raw.githubusercontent.com/BNK3R-Boy/ReadyxChalloBingBong/main/ChalloBingBong.json")
			jsondata := JSON.Load(jstr)
		} Catch e {
			return
		}
		i := 0
		For k In jsondata {
			i++
			TryStartTime := A_TickCount
			pdata := jsondata[k]
			tMBL := (k == "Twitch") ? MBL + TWITCHADD : MBL
			NewBTNdata := Array()
			NewBTNdata["TITLE"] :=  StrReplace(Trim(Menu_GetShortMenuTitle(pdata["title"], MBL+i)), "`n", " ")	
			NewBTNdata["URL"] := pdata["url"]
			ExistInHistory := History_IsIn(NewBTNdata["URL"], k, NewBTNdata["TITLE"])
			If (!ExistInHistory) || (Opt = 1) || (OptRem && !Opt) {
				(!Opt && OptRem && k = jsondata.Count()) ? OptRem := False
				If (!ExistInHistory) { ; And !((k == "Twitch") And (pdata["title"] == "off"))
					If (k == "Twitch") And (pdata["title"] == "off")
						NewBTNdata["TITLE"] := "Stream Offline"
					Else {
						History_Add(NewBTNdata["URL"], k, NewBTNdata["TITLE"])
						Sources[k]["new"] := 1
						App_SplashTimeout()
						Menu, Tray, Icon
						Menu, Tray, Icon, % Sources[k]["title"], %TF%n%k%.png,, 0
						TrayTip, %k%, % NewBTNdata["TITLE"], 20
						App_Voice(k . ": " . Menu_GetShortMenuTitle(pdata["title"], Floor(MBL*1.8))) 
						Tray_CheckNewPostings()
					}
					Menu, Tray, Rename, % Sources[k]["title"], % NewBTNdata["TITLE"]
					Sources[k]["title"] := NewBTNdata["TITLE"]
					Sources[k]["url"] := NewBTNdata["URL"]
				}
			}
			TryElapsedTime := A_TickCount - TryStartTime
			TryElapsedTime := TryElapsedTime / 1000
			tetrow .= TryElapsedTime . "s`n"
		}
		ElapsedTime := A_TickCount - StartTime
		ElapsedTime := ElapsedTime / 1000
		tetrow .= ElapsedTime . "s`n"
		If !a {
			SetTimer, %fnMainProcess%, 300000
			a := True
		}
		ElapsedTime := A_TickCount - StartTime
		ElapsedTime := ElapsedTime / 1000
		tetrow .= ElapsedTime . "s`n"
		;MsgBox, %tetrow%
	}
	If (!ONLINE AND (a OR (Opt = 1))) OR (e.Message = "error") {
		SetTimer, %fnMainProcess%, 300000
		a := False
		(Opt = 1) ? OptRem := True
	}
	History_Cleanup()
	(Opt = 2) ? (!ONLINE && a) ? App_Voice("Offline") : App_Voice("Fertig")
}

App_SplashScreen() {
  	Gui, Splash: Color, 1a2b3c
	Gui, Splash: +HwndSplashwdHwnd +LastFound +AlwaysOnTop -Caption +ToolWindow
	Gui, Splash: Add, Picture, x0 y0, %PathToSplashImage%
	Gui, Splash: Show, w%SplashPIC_widget_w% h%SplashPIC_widget_h% NA, %APPNAME% Screen
	WinSet, TransColor, 1a2b3c, ahk_id %SplashwdHwnd%
	SetTimer, %fnSplashTimeout%, -5000
}

App_SplashTimeout() {
	Gui, Splash: destroy
	SetTimer, %fnSplashTimeout%, Off
}

App_TempSetup() {
    If !FileExist(TF) 
		FileCreateDir, %TF%
	FileInstall, splash.png, %PathToSplashImage%, 1
	FileInstall, ReadyxChalloBingBong.png, %TF%%AppName%.png, 1
	FileInstall, nReadyxChalloBingBong.png, %TF%n%AppName%.png, 1
}

App_Voice(msg) {
	If (Voice && msg)
		ComObjCreate("SAPI.SpVoice").Speak(msg)
	Else If ToolTipToken {
		ToolTip, %AppName%: %msg%
		Sleep, 3000
		ToolTip,
	}
}

Arr_RemoveDuplicate(arr) {
	narr := []
	Loop % arr.Length()
	{
		value := arr.RemoveAt(1) ; otherwise Object.Pop() a little faster, but would not keep the original order
		Loop % narr.Length()
			If (value = narr[A_Index])
	    		Continue 2 ; jump to the top of the outer loop, we found a duplicate, discard it and move on
		narr.Push(value)
	}
	Return narr
}

History_Add(URL, platform, Title = "") {
	URL := platform . "|||" . URL . "|||" . Title . "`n"
	FileRead, Contents, %HistoryFile%
    FileDelete, %HistoryFile%
 	URL .= Contents
    FileAppend, %URL%, %HistoryFile%
}

History_Cleanup() {
	parray := []
	If !FileExist(HistoryFile)
		Return False
    Loop, Read, %HistoryFile%
	{
    	Loop, Parse, A_LoopReadLine, %A_Tab%
	    {
	    	If InStr(A_LoopReadLine, "|||") {
				l := StrSplit(A_LoopReadLine, "|||")
				hplatform := l[1]
				hURL := l[2]
				hTitle := l[3]
				C%hplatform%++
				parray.Push(hplatform)
			}
		}
	}
	parray := Arr_RemoveDuplicate(parray)
	NewHistoryLine := ""
	Loop, Read, %HistoryFile%
	{
		Loop, Parse, A_LoopReadLine, %A_Tab%
		{
	    	If InStr(A_LoopReadLine, "|||") {
				l := StrSplit(A_LoopReadLine, "|||")
				hplatform := l[1]
				hCn%hplatform%++
				hCn := hCn%hplatform%
				If (hCn <= HISTORYLENGTH)
					NewHistoryLine .= A_LoopReadLine . "`n"
			}
		}
	}
    FileDelete, %HistoryFile%
    FileAppend, %NewHistoryLine%, %HistoryFile%
}

History_IsIn(URL, platform, Title = "") {
	If !FileExist(HistoryFile)
		Return False
    Loop, Read, %HistoryFile%
	{
	    Loop, Parse, A_LoopReadLine, %A_Tab%
	    {
	    	hplatform := "", hURL := "", hTitle := ""
	    	hdata := StrSplit(A_LoopReadLine, "|||")
	    	hplatform := hdata[1], hURL := hdata[2], hTitle := hdata[3]
			If (URL = hURL) AND (platform = hplatform) {
				If (platform = "Twitch") {
					If (InStr(hTitle, Title))
						Return True
				} Else
					Return True
			}
	    }
	}
	Return False
}

Menu_AutoStartSetup() {
	If FileExist(A_Startup . "\" . AppName . ".lnk")
    	FileDelete, %A_Startup%\%AppName%.lnk
	Else
    	FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%AppName%.lnk
	Menu_UpdateMenuCheckmarks()
}

Menu_GetShortMenuTitle(t, l = "") {
	cl := (!l) ? MBL : l
	t := StrReplace(t, t . " - ", "")
	sarray := StrSplit(t," ")
    If (sarray.length() >= cl) {
		str := ""
		Loop, %cl%
			str .= sarray[A_Index] . " "
		t := trim(str) . "..."
	}
	Return t
}

Menu_OpenLink(bt, bno, sm, url="") {
	/*
	For k, v In Sources {
		For l, w In v
			msgbox, % k . "`n" . l . "`n" . w
	}
	*/
	For k In Sources {
		; msgbox, % Sources[k]["title"] . " == " . bt . " " . k
		If  (sm = "Tray") && (Sources[k]["title"] == bt) {
            Menu, Tray, Icon, %bt%, %TF%%k%.png,, 0
			url := Sources[k]["url"]
			Sources[k]["new"] := 0
			Break
		}
		If (sm = "Tray") && (k == bt) {
			url := Sources[k]["channelurl"]
			Break
		}
	}
	Loop, % Partner.Count() {
		Spot := A_Index
        If !Partner[Spot]["status"]
            Continue
		
		If (bt = Partner[Spot]["partner"]) {
			url := Partner[Spot]["url"]
			Break
		}
	}
	Switch bt {
		Case AppName . " - GitHub":
			url := pgGitHub
		Case RUNONSTARTUP:
			Menu_AutoStartSetup()
		Case UPDATEBUTTONTITLE:
			App_CheckUpdate(1)
		Case UNTAGNEWPOST:
		    Menu_UntagNewPost()
		Case VOICEMENU:
		    Menu_VoiceSetup()
		Case REFRESHDATAMENU, MENUTITELNAMEnews:
		    App_MainProcess(2)
		Case "Reload":
			Reload
		Case "Exit":
			ExitApp
	}
	If url {
		aug := (InStr(url, "?")) ? "&" :  "?" 
		url := url . aug . "ref=ChalloBingBong"
		Run, %url%
	}
    Tray_CheckNewPostings()
}

Menu_Setup() {
	Menu, Tray, NoStandard
	Menu, Tray, Tip, %AppTooltip%	
	Menu, Tray, Add, %MENUTITELNAMEnews%, %fnOpenLink%
	Menu, Tray, Icon, %MENUTITELNAMEnews%, %nICO%,, 0
	Loop, % SRow.Count() {
		k := SRow[A_Index]
        channelno := Sources[k]["title"]
		Menu, Tray, Add, %channelno%, %fnOpenLink%
		Menu, Tray, Icon, %channelno%, %TF%%k%.png,, 0
	}
	Menu, Tray, Add
	Menu, Tray, Add, Social-Media-Kanäle:, %fnOpenLink%
	;Menu, Tray, Icon, Social-Media-Kanäle:, %ICO%,, 0
	Loop, % SRow.Count() {
		k := SRow[A_Index]
		Menu, Tray, Add, %k%, %fnOpenLink%
		Menu, Tray, Icon, %k%, %TF%%k%.png,, 0
	}
	Menu, Tray, Add
	Menu, Tray, Add, Partner:, %fnOpenLink%
	;Menu, Tray, Icon, Partner:, %ICO%,, 0
	Loop, % Partner.Count() {
		Spot := A_Index
        If !Partner[Spot]["status"]
            Continue
	    mico := TF . Partner[Spot]["ico"]
        Menu, Tray, Add, % Partner[Spot]["partner"], %fnOpenLink%
		Menu, Tray, Icon, % Partner[Spot]["partner"], %mico%,, 0
	}
	Menu, menu, Add, %AppName% - GitHub, %fnOpenLink%
	Menu, menu, Add, %UPDATEBUTTONTITLE%, App_CheckUpdate
    Menu, menu, Add, Reload, %fnOpenLink%
    Menu, menu, Add, %RUNONSTARTUP%, %fnOpenLink%
    Menu, menu, Add, %VOICEMENU%, %fnOpenLink%
	Menu, menu, Add, %REFRESHDATAMENU%, %fnOpenLink%
	Menu, menu, Add, %UNTAGNEWPOST%, Menu_UntagNewPost
;	Menu, Tray, Add, %SUBMENUNAME%, :portals
;	Menu, Tray, Add, %PARTNERMENUNAME%, :partner
	Menu, Tray, Add
	Menu, Tray, Add, %ROSSUB%, :menu
	Menu, Tray, Icon, %ROSSUB%, %menuICO%,, 0
    Menu, Tray, Add, Exit, %fnOpenLink%
	Menu, Tray, Icon, Exit, %exitICO%,, 0
	Menu, Tray, Default, %MENUTITELNAMEnews%
	Menu, Tray, Icon, %ICO%, 0
}

Menu_UntagNewPost() {
    For k In Sources {
		Sources[k]["new"] := 0
        Menu, Tray, Icon, % Sources[k]["title"], %TF%%k%.png,, 0
	}
    Tray_CheckNewPostings()
}

Menu_UpdateMenuCheckmarks() {
	If FileExist(A_Startup . "\" . AppName . ".lnk")
		Menu, menu, Check, %RUNONSTARTUP%
	Else
		Menu, menu, Uncheck, %RUNONSTARTUP%
	If FileExist(TF . "voicetoken") {
		Voice := True
		Menu, menu, Check, %Voicemenu%
	} Else {
		Voice := False
		Menu, menu, Uncheck, %Voicemenu%
	}
}

Menu_VoiceSetup() {
	If FileExist(TF . "voicetoken") {
        App_Voice("Voicetoken wird entfernt. Ich bin nun Still.")
		Voice := False
        FileDelete, %tf%voicetoken
	} Else {
		Voice := True
        App_Voice("Voicetoken wird gesetzt. Challo Bing Bong.")
        FileAppend, I can`t dance but talk, %tf%voicetoken
	}
	Menu_UpdateMenuCheckmarks()
}



Str_FoundFirstPos(Page, beforeString1, afterString1) {
	RegExMatch(Page, "s)\Q" . beforeString1 . "\E(.*?)\Q" . afterString1 . "\E", res)
	res1 := Trim(res1)
	Return res1
}

Str_GetWebData(url) {
	If (InStr(url, "YouTube")) {
		Page := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Page.Open("GET", url, True), Page.Send()
		Page.WaitForResponse()
		response := Page.ResponseText
	} Else {
		Page := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Page.Open("GET", url, true)
		Page.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
		body := "acao=gerar_pessoa"
		Page.Send(body)
		Page.WaitForResponse()
		arr := Page.responseBody
		pData := NumGet(ComObjValue(arr) + 8 + A_PtrSize)
		length := arr.MaxIndex() + 1
		response := StrGet(pData, length, "utf-8")
	}
	response := StrReplace(response, "&amp;", "&")
	response := StrReplace(response, "&lt;", "<")
	Return response
}

Str_ReverseDirection(a1, a2, offset) {
    return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
}

Tray_CheckNewPostings() {
	c := 0
    For k In Sources
		(Sources[k]["new"] == 1) ? c++
	If (c) {
		Menu, Tray, Icon, %nICO%, 0
		TT := (c < 2) ? " - " . c . " neuer Beitrag" : " - " . c . " neue Beiträge"
	} Else {
		Menu, Tray, Icon, %ICO%, 0
		TT := "keine neue Beiträge"
	}
	Menu, Tray, Tip, %AppTooltip% %TT%
}