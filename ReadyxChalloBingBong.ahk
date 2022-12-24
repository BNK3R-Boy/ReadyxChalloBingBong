#Persistent
#NoTrayIcon
#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
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
Global AppVersion := 20221224145814
Global AppTooltip := AppName
Global TF := A_Temp . "\" . AppName . "\"
Global DEV := !A_Iscompiled
Global ICOFileName := AppName . ".png"
Global ICO := TF . ICOFileName
Global nICO := TF . "n" . ICOFileName
Global PathToSplashImage := TF . "splash.png"
Global HistoryFile := TF . "history.txt"
Global SplashPIC_widget_h := 200
Global SplashPIC_widget_w := 463
Global fnSplashTimeout := Func("App_SplashTimeout")
Global fnOpenLink := Func("Menu_OpenLink")
Global ReadedPosting := Array()
Global Sources := Array()
Global Partner := Array()
Global Voice
Global ToolTipToken := True
Global MENUTITELNAMEchannels := "Kanäle"
global MENUTITELNAMEnews := "Neueste Beiträge"
Global ROSSUB := "Menü"
Global VOICEMENU := "Sprachausgabe"
Global RUNONSTARTUP := "Autostart"
Global UNTAGNEWPOST := "neue Beiträge Markierung entfernen"
Global UPDATEBUTTONTITLE := "Auf App Update prüfen"
Global REFRESHDATAMENU := "Auf neue Beiträge prüfen"
Global MBL := 5
Global TWITCHADD := 2
Global HISTORYLENGTH := 1
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

App_AddSource(streamer, platform, channel, rss = False, stat = True) {
	Static s
	s++
	Sources[s] := []
	Sources[s]["streamer"] := streamer
	Sources[s]["platform"] := platform
	Sources[s]["channel"] := channel
	Sources[s]["rss"] := (rss) ? rss : channel
	Sources[s]["currentbuttontitle"] := platform . ": Initialisierung..."
	Sources[s]["currenttitle"] := ""
	Sources[s]["currenturl"] := ""
	Sources[s]["new"] := -1
	Sources[s]["status"] := stat
	If (platform = "YouTube" && InStr(channel, "https://www.youtube.com/channel/")) && !rss {
		cid := StrReplace(channel, "https://www.youtube.com/channel/")
		Sources[s]["rss"] := "https://www.youtube.com/feeds/videos.xml?channel_id=" . cid
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
        MsgBox, 4, %AppName% - Ein neues Update ist verfügbar, %AppVersion% aktuelle Version`n%nv% neue Version`n`nVon Github donwloaded und ReadyxChalloBingbong schließen?
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
	App_SplashScreen()
	App_CheckUpdate()
	; App_AddPartner(p, url, status)
	App_AddPartner("Instant-Gaming", "https://www.instant-gaming.com/?igr=Readyx", "IG.png", True)
	FileInstall, IG.png, %TF%IG.png, 1
	App_AddPartner("Just Legends", "https://justlegends.link/Readyx-Twitch-Panel", "JL.png", True)
	FileInstall, JL.png, %TF%JL.png, 1
	App_AddPartner("StreamerMerch", "https://www.streamermerch.de/readyx", "ST.png", True)
	FileInstall, ST.png, %TF%ST.png, 1
	; App_AddSource(streamer, platform, channel, rss, status)
	App_AddSource("Readyx", "Twitch", "https://www.twitch.tv/readyx",, True)
	FileInstall, Twitch.png, %TF%Twitch.png, 1
	FileInstall, nTwitch.png, %TF%nTwitch.png, 1
	App_AddSource("Readyx", "YouTube", "https://www.youtube.com/channel/UC_MyqSeBuocTop61oQTSXyw",, True)
	FileInstall, YouTube.png, %TF%YouTube.png, 1
	FileInstall, nYouTube.png, %TF%nYouTube.png, 1
	App_AddSource("Readyx", "Instagram", "https://www.instagram.com/readyx_ttv/", "https://imginn.com/readyx_ttv", True)
	FileInstall, Instagram.png, %TF%Instagram.png, 1
	FileInstall, nInstagram.png, %TF%nInstagram.png, 1
	App_AddSource("Readyx", "Twitter", "https://twitter.com/Readyx_", "https://rssbox.us-west-2.elasticbeanstalk.com/twitter/1287773674209251329/Readyx_?include_rts=0&exclude_replies=1", True)
	FileInstall, Twitter.png, %TF%Twitter.png, 1
	FileInstall, nTwitter.png, %TF%nTwitter.png, 1
	App_AddSource("Readyx", "TikTok", "https://www.tiktok.com/@readyx_", "https://rsshub.app/tiktok/user/@readyx_", True)
	FileInstall, Tiktok.png, %TF%Tiktok.png, 1
	FileInstall, nTiktok.png, %TF%nTiktok.png, 1
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
	    Loop, % Sources.Count() {
			TryStartTime := A_TickCount
			Spot := A_Index
			r := 0
	        If !Sources[Spot]["status"]
	            Continue
			platform := Sources[Spot]["platform"]
			Try {
				uURL := Sources[Spot]["rss"]
				NewHTMLSource := Str_GetWebData(uURL)
				Loop {
					r++
					If (platform = "Twitch") AND (r > 1) {
						uURL := "https://twitchtracker.com/" . StrReplace(Sources[Spot]["channel"], "https://www.twitch.tv/")
						NewHTMLSource := Str_GetWebData(uURL) ; fallback twitchtracker.com
					}
					version := Round(Trim(Str_FoundFirstPos(NewHTMLSource, "version=""", """")),0)
					(!version) || (platform = "Twitch") ? version := platform
					NewRSSdata := Array()
					Switch version {
						Case "1":							NewRSSdata := Str_ExtHTMLcodeXML1(NewHTMLSource, platform)
						Case "2":   						NewRSSdata := Str_ExtHTMLcodeXML2(NewHTMLSource, platform)
						Case "Twitch":						NewRSSdata := Str_ExtHTMLcodeTwitch(NewHTMLSource, Sources[Spot]["channel"])
						Case "Instagram", "Instagram2": 	NewRSSdata := Str_ExtHTMLcodeInstagram(NewHTMLSource, platform)
					}
					If (NewRSSdata["TITLE"] OR (r > 1)) AND (!InStr(NewRSSdata["TITLE"], "Willkommen auf meinem Kanal"))
						Break
				}
				If !NewRSSdata["TITLE"] OR !NewRSSdata["URL"] OR (NewRSSdata["TITLE"] == "Titel konnte nicht geladen werden.") {
					Throw Exception("error", -1)
				}
			} Catch e 
				Continue
			; NewRSSdata["TITLE"] := uURL . " : " . NewRSSdata["TITLE"]
			tMBL := (platform == "Twitch") ? MBL + TWITCHADD : MBL
			NewRSSdata["sTITLE"] := Menu_GetShortMenuTitle(NewRSSdata["TITLE"])
			ExistInHistory := History_IsIn(NewRSSdata["URL"], platform, NewRSSdata["sTITLE"])
			If (!ExistInHistory) || (Opt = 1) || (OptRem && !Opt) {
				(!Opt && OptRem && Spot = Sources.Count()) ? OptRem := False
				If (!ExistInHistory) {
					History_Add(NewRSSdata["URL"], platform, NewRSSdata["sTITLE"])
					Sources[Spot]["new"] := 1
					App_SplashTimeout()
                    Menu, Tray, Icon
					Menu, Tray, Icon, % Sources[Spot]["currentbuttontitle"], %TF%n%platform%.png,, 0
					TrayTip, %platform%, % NewRSSdata["TITLE"], 20
					App_Voice(platform . ": " . Menu_GetShortMenuTitle(NewRSSdata["TITLE"], Floor(MBL*1.8))) 
				}
				Sources[Spot]["currenttitle"] := NewRSSdata["TITLE"]
				Sources[Spot]["currenturl"] := NewRSSdata["URL"]
				NewShortButtonTitle := StrReplace(Sources[Spot]["platform"] . ": " . Menu_GetShortMenuTitle(Sources[Spot]["currenttitle"], tMBL), "&", "&&")
				Menu, Tray, Rename, % Sources[Spot]["currentbuttontitle"], %NewShortButtonTitle%
				Sources[Spot]["currentbuttontitle"] := NewShortButtonTitle
				Tray_CheckNewPostings()
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
		SetTimer, %fnMainProcess%, 5000
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
		ToolTip, ReadyxChalloBingBong: %msg%
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
	t := StrReplace(t, t . ": ", "")
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
	Loop, % Sources.Count() {
		Spot := A_Index
        If !Sources[Spot]["status"]
            Continue
		platform := Sources[Spot]["platform"]
		If  (sm = "Tray") && (Sources[Spot]["currentbuttontitle"] == bt) {
            Menu, Tray, Icon, %bt%, %TF%%platform%.png,, 0
			url := Sources[Spot]["currenturl"]
			Sources[Spot]["new"] := 0
			Break
		}
		If (sm = "Tray") && (Sources[Spot]["streamer"] . " - " . platform == bt) {
			url := Sources[Spot]["channel"]
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
	If url
		Run, %url%
    Tray_CheckNewPostings()
}

Menu_Setup() {
	Menu, Tray, NoStandard
	Menu, Tray, Icon, %ICO%, 0
	Menu, Tray, Tip, %AppTooltip%	
	Loop, % Partner.Count() {
		Spot := A_Index
        If !Partner[Spot]["status"]
            Continue
	    mico := TF . Partner[Spot]["ico"]
        Menu, Tray, Add, % Partner[Spot]["partner"], %fnOpenLink%
		Menu, Tray, Icon, % Partner[Spot]["partner"], %mico%,, 0
	}
	Menu, Tray, Add
	Menu, Tray, Add, %MENUTITELNAMEnews%, %fnOpenLink%
	Menu, Tray, Icon, %MENUTITELNAMEnews%, %nICO%,, 0
	Loop, % Sources.Count() {
		Spot := A_Index
        If !Sources[Spot]["status"]
            Continue
		platform := Sources[Spot]["platform"]
        channelno := Sources[Spot]["streamer"] . " - " . platform
        Menu, Tray, Add, % Sources[Spot]["currentbuttontitle"], %fnOpenLink%
		Menu, Tray, Icon, % Sources[Spot]["currentbuttontitle"], %TF%%platform%.png,, 0
	}
	Menu, Tray, Add
	Menu, Tray, Add, Kanäle, %fnOpenLink%
	Menu, Tray, Icon, Kanäle, %ICO%,, 0
	Loop, % Sources.Count() {
		Spot := A_Index
        If !Sources[Spot]["status"]
            Continue
		platform := Sources[Spot]["platform"]
        channelno := Sources[Spot]["streamer"] . " - " . platform
		If (platform != "Twitch") {
	        Menu, Tray, Add, %channelno%, %fnOpenLink%
			Menu, Tray, Icon, %channelno%, %TF%%platform%.png,, 0
		}
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
    Menu, Tray, Add, Exit, %fnOpenLink%
	Menu, Tray, Icon, %ICO%, 0
}

Menu_UntagNewPost() {
	Loop, % Sources.Count() {
		Spot := A_Index
        If !Sources[Spot]["status"]
            Continue
		platform := Sources[Spot]["platform"]
        Sources[Spot]["new"] := 0
        Menu, Tray, Icon, % Sources[Spot]["currentbuttontitle"], %TF%%platform%.png,, 0
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

Str_ExtHTMLcodeInstagram(html, platform) {
	html2 := StrReplace(html, ">", ">`n")
	Item := Str_FoundFirstPos(html, "<div class=""item"">", "</div>   <div class=""item"">")
	wt := Str_FoundFirstPos(Item, "alt=""", """")
	lk := Str_FoundFirstPos(Item, "<a href=""", """>")
	lk := "https://www.instagram.com" . lk
	(!wt) ? wt := InfoArray[platform]["TITLE"]
	(!lk && InStr(lk, "/p/")) ? lk := InfoArray[platform]["URL"]
	Return {TITLE: (wt), URL: (lk)}
}

Str_ExtHTMLcodeTwitch(html, channel) {
	wt := Str_FoundFirstPos(Str_FoundFirstPos(html, "<div id=""channel-streams"">", "</div>"), "title=""", """ data-toggle=")
	wt := StrReplace(wt, "&lt;", "<")
	online := InStr(html, "live-indicator-container") ? "LIVE!"	
	If !wt {
		TitleArray := []
		narr := []
		Array := StrSplit(Str_FoundFirstPos(html, "<script type=""application/ld+json"">[{", "}]</script>"), ",")
		title := StrSplit(Array[3], ":")
		TitleArray[1] := Str_FoundFirstPos(title[2], """", """")
		TitleArray[2] := Str_FoundFirstPos(html, "<meta name=""description"" content=""", """/>")
		TitleArray[3] := Str_FoundFirstPos(html, "<meta name=""twitter:description"" content=""", """/>")
		TitleArray[4] := Str_FoundFirstPos(html, "<meta property=""og:description"" content=""", """/>")
		arrmax := TitleArray.Count()
		Loop, %arrmax%
		{
			narr[A_Index] := []
			narr[A_Index]["title"] := TitleArray[A_Index]
			C_Index := A_Index
			hits := 0
			Loop, %arrmax%
				(C_Index != A_Index) AND (TitleArray[C_Index] == TitleArray[A_Index]) ? hits++
			narr[A_Index]["hits"] := hits
			C_Title .= hits . ","
		}
		Sort, C_Title, F Str_ReverseDirection D,
		CT := StrSplit(C_Title, ",")
		res := CT[1]
		Loop % narr.Count()
		{
			If (narr[A_Index]["hits"] == res) {
				wt := narr[A_Index]["title"]
				Break
			}
		}
		online := StrSplit(StrReplace(Array[13], "}"), ":")
		online := (online[2]) ? "LIVE!"
	} Else
		wt := StrReplace(wt, "&amp;", "&")
	(wt) ? wt := online . " " . wt 
	Return {TITLE: (wt), URL: (channel)}
}

Str_ExtHTMLcodeXML1(html, platform) { ; YT Playlist
	html := StrReplace(html, " />", "/>")
	If (platform = "TikTok") {
		item := Str_FoundFirstPos(html, "<item>", "</item>")
		wt := Str_FoundFirstPos(item, "<title>", "</title>")
		wt := Str_FoundFirstPos(wt, "<![CDATA[", "]]>")
		lk := Str_FoundFirstPos(item, "<link>", "</link>")
	} Else {
		Feed := Str_FoundFirstPos(html, "<feed", "</feed>")
		Entry := Str_FoundFirstPos(Feed, "<entry>", "</entry>")
		wt := Str_FoundFirstPos(Entry, "<title>", "</title>")
		lk := Str_FoundFirstPos(Entry, "href=""", """/>")
	}
	Return {TITLE: (wt), URL: (lk)}
}

Str_ExtHTMLcodeXML2(html, platform) {
	XML := ComObjCreate("MSXML2.DOMDocument.6.0")
	XML.Async := False
	XML.LoadXML(html)
	XMLtitle := XML.SelectSingleNode("//channel/item/title")
	wt := XMLtitle.Text
	If (platform = "TikTok") {
		XMLlink := XML.SelectSingleNode("//channel/item/guid")
		lk := InfoArray[platform]["CURL"] . "/video/" . XMLlink.Text
	} Else {
		XMLlink := XML.SelectSingleNode("//channel/item/link")
		lk := XMLlink.Text
	}
	Return {TITLE: (wt), URL: (lk)}
}

Str_FoundFirstPos(Page, beforeString1, afterString1) {
	RegExMatch(Page, "s)\Q" . beforeString1 . "\E(.*?)\Q" . afterString1 . "\E", res)
	res1 := StrReplace(res1, "&amp;", "&")
	res1 := StrReplace(res1, "\u0026", "&")
	res1 := Trim(res1)
	Return res1
}

Str_GetWebData(url) {
	If (InStr(url, "YouTube")) {
		Page := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		Page.Open("GET", url, True), Page.Send()
		Page.WaitForResponse()
		Return Page.ResponseText
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
		Return %response%
	}
}

Str_ReverseDirection(a1, a2, offset) {
    return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
}

Tray_CheckNewPostings() {
	c := 0
    Loop, % Sources.Count()
		(Sources[A_Index]["new"] = 1 && Sources[A_Index]["status"]) ? c++
	If (c) {
		Menu, Tray, Icon, %nICO%, 0
		TT := (c < 2) ? " - " . c . " neuer Beitrag" : " - " . c . " neue Beiträge"
	} Else {
		Menu, Tray, Icon, %ICO%, 0
		TT := "keine neue Beiträge"
	}
	Menu, Tray, Tip, %AppTooltip% %TT%
}