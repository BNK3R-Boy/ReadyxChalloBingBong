﻿#Persistent
#NoTrayIcon
#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Global AppName := "ReadyxChalloBingBong"
Global AppVersion := "20221117025053"
Global AppTooltip := AppName
Global TF := A_Temp . "\" . AppName
Global DEV := !A_Iscompiled
Global ICOFileName := AppName . ".png"
Global ICO := TF . ICOFileName
Global nICO := TF . "n" . ICOFileName
Global PathToSplashImage := TF . "splash.png"
Global SplashPIC_widget_h := 200
Global SplashPIC_widget_w := 463

Global fnOpenLink := Func("Menu_OpenLink")

Global ReadedPosting := Array()
Global Sources := Array()

Global Voice

Global SUBMENUNAME := "Kanäle"
Global ROSSUB := "Menü"
Global VOICEMENU := "Sprachausgabe"
Global RUNONSTARTUP := "Autostart"
Global UNTAGNEWPOST := "neue Beiträge Markierung entfernen"
Global UPDATEBUTTONTITLE := "Auf App update prüfen"

Global MBL := 5
Global MainProcess := Func("Main_Process")
; AddSource(streamer, platform, channel, rss)
AddSource("Readyx", "Twitch", "https://www.twitch.tv/readyx")
AddSource("Readyx", "Twitter", "https://twitter.com/Readyx_", "https://rssbox.us-west-2.elasticbeanstalk.com/twitter/1287773674209251329/Readyx_?include_rts=0&exclude_replies=1")
AddSource("Readyx", "Instagram", "https://www.instagram.com/readyx_ttv/", "https://imginn.com/readyx_ttv")
AddSource("Readyx", "TikTok", "https://www.tiktok.com/@readyx_", "https://rsshub.app/tiktok/user/@readyx_")
AddSource("Readyx", "YouTube", "https://www.youtube.com/channel/UC_MyqSeBuocTop61oQTSXyw")


App_Inizial()
Main_Process(1)

SetTimer, %MainProcess%, 900000

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Main_Process(OnFirstLoad = 0) {
	If (!IsOnline())
		Return

    Loop, % Sources.Count() {
		Spot := A_Index
        If !Sources[Spot]["status"]
            Continue

		platform := Sources[Spot]["platform"]

		Try NewHTMLSource := GetWebData(Sources[Spot]["rss"])
		version := ""
		version := round(trim(FoundFirstPos(NewHTMLSource, "version=""", """")),0)
		(!version) || (platform = "Twitch") ? version := platform

		If (platform = 1) {
			;msgbox, %platform% - %version%`n%html%
			FormatTime, timestamp, , yyyyMMddHHmmss
			f := timestamp . platform . ".txt"
			hf := StrReplace(NewHTMLSource, "><", ">`n<")
			FileAppend, %hf% , %f%
		}
		;msgbox, %platform%`n%version%`n%html%
		Switch version {
			Case "1":							NewRSSdata := ExtHTMLcodeXML1(NewHTMLSource, platform)
			Case "2":   						NewRSSdata := ExtHTMLcodeXML2(NewHTMLSource, platform)
			Case "Twitch":						NewRSSdata := ExtHTMLcodeTwitch(NewHTMLSource, Sources[Spot]["channel"])
			Case "Instagram", "Instagram2": 	NewRSSdata := ExtHTMLcodeInstagram(NewHTMLSource, platform)
		}

		NewRSSdata["sTITLE"] := GetShortMenuTitle(NewRSSdata["TITLE"])
		ExistInHistory := History_IsIn(NewRSSdata["URL"], NewRSSdata["sTITLE"])
        If !ExistInHistory || OnFirstLoad {
            If (!ExistInHistory) {
				History_Add(NewRSSdata["URL"], NewRSSdata["sTITLE"])
				Sources[Spot]["new"] := 1
                Menu, Tray, Icon, % Sources[Spot]["currentbuttontitle"], %TF%n%platform%.png,, 0
            	TrayTip, %AppName%: %platform%, % NewRSSdata["TITLE"], 20
            	Voice(NewRSSdata["sTITLE"])
			}
			Sources[Spot]["currenttitle"] := NewRSSdata["TITLE"]
			Sources[Spot]["currenturl"] := NewRSSdata["URL"]
			NewShortButtonTitle := GetShortMenuTitle(Sources[Spot]["currenttitle"])
			Menu, Tray, Rename, % Sources[Spot]["currentbuttontitle"], %NewShortButtonTitle%
			Sources[Spot]["currentbuttontitle"] := NewShortButtonTitle
			Tray_CheckNewPostings()
		}
	}
}

History_Add(URL, Title = "") {
	(URL == "https://www.twitch.tv/readyx") ? URL := URL . " " . Title
    FileAppend, %URL%`n, %tf%history.txt
}

History_IsIn(URL, Title = "") {
	If !FileExist(tf . "history.txt")
		Return False
	(InStr(URL, "www.twitch.tv")) ? URL := URL . " " . Title
    Loop, Read, %tf%history.txt
	{
	    Loop, Parse, A_LoopReadLine, %A_Tab%
	    {
	        If (InStr(URL, A_LoopField)) {
				; msgbox, yes %URL% %A_LoopField%
				Return True
			}
	    }
	}
	Return False
}

GetShortMenuTitle(t) {
	t := StrReplace(t, t . ": ", "")
	sarray := StrSplit(t," ")
    If (sarray.length() >= MBL) {
		str := ""
		Loop, %MBL%
			str .= sarray[A_Index] . " "
		t := trim(str) . "..."
	}
	Return t
}

ExtHTMLcodeInstagram(html, platform) {
	Item := FoundFirstPos(html, "<div class=""item"">", "</div>   <div class=""item"">")
	wt := FoundFirstPos(Item, "alt=""", "> </a>")
	lk := FoundFirstPos(Item, "<a href=""", """><img")
	lk := "https://www.instagram.com" . lk
	(!wt) ? wt := InfoArray[platform]["TITLE"]
	(!lk && InStr(lk, "/p/")) ? lk := InfoArray[platform]["URL"]
	Return {TITLE: (wt), URL: (lk)}
}

ExtHTMLcodeTwitch(html, channel) {
	wt := FoundFirstPos(html, "<meta name=""description"" content=""", "/>")
	wt := StrReplace(StrReplace(wt, "[", "<"), "]", ">")
	wt := RegExReplace(wt, "i)[^0-9a-zA-Z!.<>: &;]")
    wt := StrReplace(wt, "&amp;", "&")
	wt := StrReplace(StrReplace(wt, ">", "]"), "<", " [")
	wt := StrReplace(StrReplace(wt, "  ", " "), "  ", " ")
	lk := FoundFirstPos(html, "<link rel=""alternate"" hreflang=""x-default"" href=""", """/>")
	(!wt) ? wt := "Titel konnte nicht geladen werden."
	(!lk) ? lk := channel

	Return {TITLE: (wt), URL: (lk)}

}

ExtHTMLcodeXML1(html, platform) { ; YT Playlist
	html := StrReplace(html, " />", "/>")
	If (platform = "TikTok") {
		item := FoundFirstPos(html, "<item>", "</item>")
		wt := FoundFirstPos(item, "<title>", "</title>")
		wt := FoundFirstPos(wt, "<![CDATA[", "]]>")
		lk := FoundFirstPos(item, "<link>", "</link>")
	} Else {
		Feed := FoundFirstPos(html, "<feed", "</feed>")
		Entry := FoundFirstPos(Feed, "<entry>", "</entry>")
		wt := FoundFirstPos(Entry, "<title>", "</title>")
		lk := FoundFirstPos(Entry, "href=""", """/>")
	}

	Return {TITLE: (wt), URL: (lk)}
}

ExtHTMLcodeXML2(html, platform) {
	XML := ComObjCreate("MSXML2.DOMDocument.6.0")
	XML.Async := false
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

FoundFirstPos(Page, beforeString1, afterString1) {
	RegExMatch(Page, "s)\Q" . beforeString1 . "\E(.*?)\Q" . afterString1 . "\E", res)
	Return res1
}



Voice(msg) {
	(Voice) ? ComObjCreate("SAPI.SpVoice").Speak(msg)
}



IsOnline() {
	RunWait, %ComSpec% /c ping -n 1 1.1.1.1 ,, Hide UseErrorLevel
	Return !ErrorLevel
}










































; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddSource(streamer, platform, channel, rss = false) {
	Static s
	s++
	Sources[s] := []
	Sources[s]["streamer"] := streamer
	Sources[s]["platform"] := platform
	Sources[s]["channel"] := channel
	Sources[s]["rss"] := ((platform = "Twitch") && InStr(channel, "https://www.twitch.tv/") && !rss) ? channel : rss
	Sources[s]["currentbuttontitle"] := s . ": Initialisierung..."
	Sources[s]["currenttitle"] := ""
	Sources[s]["currenturl"] := ""
	Sources[s]["new"] := -1
	Sources[s]["status"] := 1

	If (platform = "YouTube" && InStr(channel, "https://www.youtube.com/channel/")) && !rss {
		cid := StrReplace(channel, "https://www.youtube.com/channel/")
		Sources[s]["rss"] := "https://www.youtube.com/feeds/videos.xml?channel_id=" . cid
	}
}

GetWebData(url) {
	Page := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	Page.Open("GET", url, true)
	Page.Send()
	Page.WaitForResponse()
	Return Page.ResponseText
}

App_CheckUpdate(m = 0) {
	uurl := "https://raw.githubusercontent.com/BNK3R-Boy/" . AppName . "/main/version"
    nv := "|||"
	If FileExist(TF . "version")
		FileRead, nv, %TF%version
	If (nv == "|||")
		Loop, 3 {
			Try nv := GetWebData(uurl)
			If nv
				Break
		}

	If (InStr(nv, "Not Found")) {
		MsgBox,, %AppName% - Prüfung auf Update gescheitert, %nv%
		Return
	} Else If nv && (nv > AppVersion) {
        MsgBox, 4, %AppName% - Ein neues Update ist verfügbar, %AppVersion% aktuelle Version`n%nv% neue Version`n`nDownload auf Github anzeigen?
		IfMsgBox Yes
		    Menu_OpenLink("", "", "", "https://github.com/BNK3R-Boy/" . AppName)
		Return
	}
	If (m)
        MsgBox,, %AppName% - Prüfung auf Update Abgeschlossen, Kein Update verfügbar.
}

App_Inizial() {
	App_TempSetup()
	App_SplashScreen()
	App_CheckUpdate()
	Menu_Setup()
	Menu_UpdateMenuCheckmarks()
	Tray_CheckNewPostings()
	Menu, Tray, Icon
	Gui, Splash: destroy
}

App_SplashScreen() {
  	Gui, Splash: Color, 1a2b3c
	Gui, Splash: +HwndSplashwdHwnd +LastFound +AlwaysOnTop -Caption +ToolWindow
	Gui, Splash: Add, Picture, x0 y0, %PathToSplashImage%
	Gui, Splash: Show, w%SplashPIC_widget_w% h%SplashPIC_widget_h% NA, Power Reminder Splash Screen
	WinSet, TransColor, 1a2b3c, ahk_id %SplashwdHwnd%
}

App_TempSetup() {
    If !FileExist(TF)
		FileCreateDir, %TF%
	If !FileExist(PathToSplashImage)
		FileInstall, splash.png, %PathToSplashImage%, 1

	iconArray := ["Instagram", "nInstagram", "Tiktok", "nTiktok", "Twitch", "nTwitch", "Twitter", "nTwitter", "YouTube", "nYouTube", AppName, "n" . AppName]
	Loop, % iconArray.length() {
		filename := iconArray[A_Index]
		pathto := TF . iconArray[A_Index] . ".png"
		If !FileExist(pathto) {
			Switch filename {
				Case "Instagram":
						FileInstall, Instagram.png, %pathto%, 1
				Case "nInstagram":
						FileInstall, nInstagram.png, %pathto%, 1
				Case "Tiktok":
						FileInstall, Tiktok.png, %pathto%, 1
				Case "nTiktok":
						FileInstall, nTiktok.png, %pathto%, 1
				Case "Twitch":
						FileInstall, Twitch.png, %pathto%, 1
				Case "nTwitch":
						FileInstall, nTwitch.png, %pathto%, 1
				Case "Twitter":
						FileInstall, Twitter.png, %pathto%, 1
				Case "nTwitter":
						FileInstall, nTwitter.png, %pathto%, 1
				Case "YouTube":
						FileInstall, YouTube.png, %pathto%, 1
				Case "nYouTube":
						FileInstall, nYouTube.png, %pathto%, 1
				Case AppName:
						FileInstall, AppName.png, %pathto%, 1
				Case "n" . AppName:
						FileInstall, nAppName.png, %pathto%, 1
			}
		}
	}

	FileInstall, version, %TF%version, 1
}

Menu_AutoStartSetup() {
	If FileExist(A_Startup . "\" . AppName . ".lnk")
    	FileDelete, %A_Startup%\%AppName%.lnk
	Else
    	FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%AppName%.lnk
	Menu_UpdateMenuCheckmarks()
}

Menu_GetShortTitle(platform) {
	t := InfoArray[platform]["TITLE"]
	t := StrReplace(t, platform . ": ", "")
	sarray := StrSplit(t," ")
    If (sarray.length() >= MBL) {
		str := ""
		Loop, %MBL%
			str .= sarray[A_Index] . " "
		t := trim(str) . "..."
	}
	Return platform . ": " . t
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
		If (sm = "portals") && (Sources[Spot]["streamer"] . " - " . platform == bt) {
			url := Sources[Spot]["channel"]
			Break
		}
	}

	If (bt = AppName . " - GitHub")
		url := "https://bnk3r-boy.github.io/" . AppName

	If (bt = RUNONSTARTUP) {
		Menu_AutoStartSetup()
		Return
	}

	If (bt = UPDATEBUTTONTITLE) {
		App_CheckUpdate(1)
		Return
	}

	If (bt = UNTAGNEWPOST) {
        Menu_UntagNewPost()
		Return
	}

	If (bt = VOICEMENU) {
        Menu_VoiceSetup()
		Return
	}

	If (bt = "Reload") {
		Reload
		Return
	}

	If (bt = "Exit") {
		ExitApp
		Return
	}

	If url
		Run, %url%
    Tray_CheckNewPostings()
}

Menu_Setup() {
	Menu, Tray, NoStandard
	Menu, Tray, Icon, %ICO%, 0
	Menu, Tray, Tip, %AppTooltip%
    Loop, % Sources.Count() {
		Spot := A_Index
        If !Sources[Spot]["status"]
            Continue
		platform := Sources[Spot]["platform"]
        channelno := Sources[Spot]["streamer"] . " - " . platform
        Menu, Tray, Add, % Sources[Spot]["currentbuttontitle"], %fnOpenLink%
		Menu, Tray, Icon, % Sources[Spot]["currentbuttontitle"], %TF%%platform%.png,, 0
        Menu, portals, Add, %channelno%, %fnOpenLink%
		Menu, portals, Icon, %channelno%, %TF%%platform%.png,, 0

	}
	Menu, menu, Add, %AppName% - GitHub, %fnOpenLink%
	Menu, menu, Add, %UPDATEBUTTONTITLE%, App_CheckUpdate
    Menu, menu, Add, Reload, %fnOpenLink%
    Menu, menu, Add, %RUNONSTARTUP%, %fnOpenLink%
    Menu, menu, Add, %VOICEMENU%, %fnOpenLink%
	Menu, menu, Add, %UNTAGNEWPOST%, Menu_UntagNewPost
	Menu, Tray, Add
	Menu, Tray, Add, %SUBMENUNAME%, :portals
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
        ComObjCreate("SAPI.SpVoice").Speak("Voicetoken wird entfernt. Ich bin nun Still.")
        FileDelete, %tf%voicetoken
	} Else {
        ComObjCreate("SAPI.SpVoice").Speak("Voicetoken wird gesetzt. Challo Bing Bong.")
        FileAppend, I can't dance but talk, %tf%voicetoken
	}
	Menu_UpdateMenuCheckmarks()
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