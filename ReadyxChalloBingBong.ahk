#Persistent
#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Global AppName := "ReadyxChalloBingBong"
Global AppVersion := "20221110212828"
Global COMHOME := "Readyx Webseite"
Global AppTooltip := AppName
Global TF := A_Temp . "\" . AppName . "\"
Global DEV := !A_Iscompiled
Global ICOFileName := AppName . "-16icon.png"
Global ICO := TF . ICOFileName
Global ICO2 := TF . "n" . ICOFileName
Global PathToSplashImage := TF . "splash.png"
SetTemp()
Global SplashPIC_widget_h := 200
Global SplashPIC_widget_w := 463
Global fnCheck4Updates := Func("Check4Updates")
Global fnOpenLink := Func("OpenLink")
Global fnRefreshMenu := Func("RefreshMenu")
Global RUNONSTARTUP := "Autostart"
Global StaticLinks := []
Global NewPostCount := 0
Global MBL := 5
Global SUBMENUNAME := "Readyx Kanäle"
Global UPDATEBUTTONTITLE := "Auf App update prüfen"
Global GHSUB := "dev"
Global ROSSUB := "dev"
Global Voicemenu := "Sprachausgabe"
Global Voice
Global UntagNewPost := "neue Beiträge Markierung entfernen"
Global MaxNewPostCount
Global pArray := ["YouTube", "Twitter", "Instagram", "TikTok", "Twitch", "Readyx"]
ONLINE := isOnline()

Global InfoArray := {Instagram: ({TITLE: "Instagram: " . ((ONLINE) ? "Loading..." : "Disconnected")
			, URL: -1
			, HURL: 0
			, BHTITLE: ""
			, HTITLE: "Initialisation..."
			, RSS: "https://imginn.com/USERNAME"
			, CURL: "https://www.instagram.com/USERNAME/"
			, STATE: 0
			, NewPost: 0})
			, Twitch: ({TITLE: "Twitch: " . ((ONLINE) ? "Loading..." : "Disconnected"), URL: -1, HURL: 0, BHTITLE: "", HTITLE: "Initialisation...", RSS: "https://www.twitch.tv/readyx", CURL: "https://www.twitch.tv/readyx", STATE: 1, NewPost: 0}) ; https://twitchrss.appspot.com/vod/yvraldis
			, YouTube: ({TITLE: "YouTube: " . ((ONLINE) ? "Loading..." : "Disconnected"), URL: -1, HURL: 0, BHTITLE: "", HTITLE: "Initialisation...", RSS: 0, CURL: "https://www.youtube.com/channel/UC_MyqSeBuocTop61oQTSXyw", STATE: 1, NewPost: 0})
			, TikTok: ({TITLE: "TikTok: " . ((ONLINE) ? "Loading..." : "Disconnected"), URL: -1, HURL: 0, BHTITLE: "", HTITLE: "Initialisation...", RSS: "https://rsshub.app/tiktok/user/@readyx_", CURL: "https://www.tiktok.com/@readyx_", STATE: 1, NewPost: 0})
			, Twitter: ({TITLE: "Twitter: " . ((ONLINE) ? "Loading..." : "Disconnected"), URL: -1, HURL: 0, BHTITLE: "", HTITLE: "Initialisation...", RSS: "https://rssbox.herokuapp.com/twitter/1287773674209251329/Readyx_?include_rts=0&exclude_replies=1", CURL: "https://twitter.com/Readyx_", STATE: 1, NewPost: 0})
			, Instagram: ({TITLE: "Instagram: " . ((ONLINE) ? "Loading..." : "Disconnected"), URL: -1, HURL: 0, BHTITLE: "", HTITLE: "Initialisation...", RSS: "https://imginn.com/readyx_ttv", CURL: "https://www.instagram.com/readyx_ttv/", STATE: 1, NewPost: 0})}

YouTubeRSSFeedURLbuilder()
; Loop, % pArray.Length()
; 	msgbox, % pArray[A_Index] . "`nRSS: " . InfoArray[pArray[A_Index]]["RSS"] . "`n`nTitle: " . InfoArray[pArray[A_Index]]["TITLE"] . "`n`nURL: " . InfoArray[pArray[A_Index]]["URL"] . "`n`nstate: " . InfoArray[pArray[A_Index]]["state"]

Loop, % pArray.Length()
	(InfoArray[pArray[A_Index]]["STATE"]) ? MaxNewPostCount++

CheckAPPUpdate()
SplashScreen()
Menu, Tray, NoStandard
Menu, Tray, Icon, %ICO%, 0
Menu, Tray, Tip, %AppTooltip%
;AddMenuStatic("Tray", COMHOME, "https://www.de/")
;AddMenuStatic("Tray", "", "")
BuildStaticMenu()
BuildDynamicMenu()
AddMenuStatic("Tray", "", "")
AddMenuStatic("Tray", SUBMENUNAME, ":webportals")
;AddMenuStatic("Tray", "Etsy Store", "https://www.etsy.com/de/shop/Yvraldis")
;AddMenuStatic("Tray", "Discord", "https://discord.gg/chKcXfY")
AddMenuStatic("Tray", "", "")
AddMenuStatic(GHSUB, AppName . " - GitHub", "https://github.com/BNK3R-Boy/" . AppName)
AddMenuStatic("dev", UPDATEBUTTONTITLE, "CheckAPPUpdate")
AddMenuStatic("dev", "Reload", "Reload")
AddMenuStatic("Tray", "Menu", ":dev")
AddMenuStatic(ROSSUB, Voicemenu, "Voice")
AddMenuStatic(ROSSUB, RUNONSTARTUP, "ROS")
AddMenuStatic(ROSSUB, UntagNewPost, "UntagNewPost")
AddMenuStatic("Tray", "Exit", "Exit")
BuildStaticMenu()
;Menu, Tray, Icon, %COMHOME%, %TF%bluedot-16icon.png,, 0
Menu, Tray, Icon, %SUBMENUNAME%, %TF%ReadyxChalloBingBong-16icon.png,, 0
;Menu, Tray, Default, %COMHOME%
RefreshMenu(1)
Check4Updates()
StartUp()
SetTimer, %fnRefreshMenu%, 30000
Menu, Tray, Icon
Gui, Splash: destroy

/*
f8::
	ToolTip, Check 4 Updates
	Check4Updates()
	ToolTip,
Return
*/

AddMenu(m, n, sub="") {
	If (n) && (!sub)
		Menu, %m%, Add, %n%, %fnOpenLink%
	Else If (n) && (sub)
		Menu, %m%, Add, %n%, %sub%
	Else
		Menu, %m%, Add
}

AddMenuStatic(m,t,url) {
	If (InStr(url, ":") = 1) {
		sub := url
		url := ""
	}
    StaticLinks.Push({MENU: (m), TITLE: (t), URL: (url), SUB: (sub)})
}

BuildDynamicMenu() {
    Loop, % pArray.Length() {
		platform := pArray[A_Index]
	    If (InfoArray[platform]["STATE"]) {
			t := InfoArray[platform]["TITLE"]
	        InfoArray[platform]["BHTITLE"] := t
			AddMenu("Tray", t)
			AddMenu("webportals", platform)
			i := TF . platform . "-16icon.png"
            Menu, Tray, Icon, %t%, %i%,, 0
            Menu, webportals, Icon, %platform%, %TF%%platform%-16icon.png,, 0
		}
	}
}

BuildStaticMenu() {
	Loop, % StaticLinks.Length()
	    AddMenu(StaticLinks[A_Index]["MENU"], StaticLinks[A_Index]["TITLE"], StaticLinks[A_Index]["SUB"])
}

Check4Updates() {
    Loop, % pArray.Length() {
        platform := pArray[A_Index]
		If (InfoArray[platform]["STATE"] && isOnline()) {
			GetInfoArray(platform)
			nt := InfoArray[platform]["TITLE"]
			bt := InfoArray[platform]["BHTITLE"]
			ht := InfoArray[platform]["HTITLE"]
			If (nt != ht) {
				st := GetShortMenuTitle(platform)
				Menu, Tray, Rename, %bt% , %st%
				InfoArray[platform]["BHTITLE"] := st
				InfoArray[platform]["HTITLE"] := nt
                If ((!InStr(ht, "Loading...") && !InStr(ht, "Disconnected") && !InStr(ht, "Temporary not available"))) && (InfoArray[platform]["NewPost"]) {
					TrayTip, %AppName%: %platform%, %nt%, 20
					SetToolTipIcon()
					(DEV || Voice) ? ComObjCreate("SAPI.SpVoice").Speak(StrReplace(InfoArray[platform]["TITLE"], "ReadyxChalloBingBong: "))
					; MsgBox,, %Msg%, %nt%
				}
			}
		}
	}
	SetToolTipIcon()
}

CheckAPPUpdate(m = 0) {
	uurl := "https://raw.githubusercontent.com/BNK3R-Boy/" . AppName . "/main/version"
    nv := "|||"
	If FileExist(TF . "version")
		FileRead, nv, %TF%version
	If (nv == "|||")
		Loop, 3 {
			Try nv := GetWebData("", uurl)
			If nv
				Break
		}

	If (InStr(nv, "Not Found")) {
		MsgBox,, %AppName% - Prüfung auf Update gescheitert, %nv%
		Return
	} Else If nv && (nv > AppVersion) {
        MsgBox, 4, %AppName% - Ein neues Update ist verfügbar, %AppVersion% aktuelle Version`n%nv% neue Version`n`nDownload auf Github anzeigen?
		IfMsgBox Yes
		    OpenLink("", "", "", "https://github.com/BNK3R-Boy/" . AppName)
		Return
	}
	If (m)
        MsgBox,, %AppName% - Prüfung auf Update Abgeschlossen, Kein Update verfügbar.
}

ClearStr(str) {
	str := StrReplace(str, "&amp;", "&")
	str := RegExReplace(str, "[^\w\^\-\[\]\.!@#$%&ß*\(\)/+':;~?,öäüÖÄÜ|]", " ")
	Loop, 10
		str := StrReplace(str, "  ", " ")
	str := StrReplace(str, "`n", "")
	str := RegExReplace(str, "[&?]\w+;")
	str := StrReplace(str, " & ", "'n'")
	Return trim(str)
}

ExHTMLcodeInstagram(html, platform) {
	Item := FoundFirstPos(html, "<div class=""item"">", "</div>   <div class=""item"">")
	wt := FoundFirstPos(Item, "alt=""", "> </a>")
	lk := FoundFirstPos(Item, "<a href=""", """><img")
	lk := "https://www.instagram.com" . lk
	(!wt) ? wt := InfoArray[platform]["TITLE"]
	(!lk && InStr(lk, "/p/")) ? lk := InfoArray[platform]["URL"]
	Return {TITLE: (wt), URL: (lk)}
}

ExHTMLcodeTwitch(html) {
	wt := FoundFirstPos(html, "<meta name=""description"" content=""", "/>")
	lk := FoundFirstPos(html, "<link rel=""alternate"" hreflang=""x-default"" href=""", """/>")
	(!wt) ? wt := "Temporary not available"
	(!lk) ? lk := "http://www.twitch.tv"
	;AppTooltip := AppName . "`nTwitch: " . ClearStr(wt)
	;Menu, Tray, Tip, %AppTooltip%
	Return {TITLE: (wt), URL: (lk)}
}

ExHTMLcodeXML1(html, platform) { ; YT Playlist
	html := StrReplace(html, " />", "/>")
	Feed := FoundFirstPos(html, "<feed", "</feed>")
    InfoArray[platform][CURL] := FoundFirstPos(Feed, "href=""", """")
	Entry := FoundFirstPos(Feed, "<entry>", "</entry>")
	wt := FoundFirstPos(Entry, "<title>", "</title>")
	If (platform = "Twitter") {
		lk := FoundFirstPos(Entry, "<id>twitter:tweet:", "</id>")
		lk := InfoArray[platform]["CURL"] . "/status/" . lk
	} Else If (platform = "TikTok") {
		item := FoundFirstPos(html, "<item>", "</item>")
		wt := FoundFirstPos(item, "<title>", "</title>")
		wt := FoundFirstPos(wt, "<![CDATA[", "]]>")
		lk := FoundFirstPos(item, "<link>", "</link>")
	} Else {
		lk := FoundFirstPos(Entry, "href=""", """/>")
	}
		
	Return {TITLE: (wt), URL: (lk)}
}

ExHTMLcodeXML2(html, platform) {
	XML := ComObjCreate("MSXML2.DOMDocument.6.0")
	XML.Async := false
	XML.LoadXML(html)
	XMLtitle := XML.SelectSingleNode("//channel/item/title")
	If (platform = "TikTok") {
		XMLlink := XML.SelectSingleNode("//channel/item/guid")
		lk := InfoArray[platform]["CURL"] . "/video/" . XMLlink.Text
	} Else {
		XMLlink := XML.SelectSingleNode("//channel/item/link")
		lk := XMLlink.Text
	}
		wt := XMLtitle.Text
	Return {TITLE: (wt), URL: (lk)}
}

FoundFirstPos(Page, beforeString1, afterString1) {
	RegExMatch(Page, "s)\Q" . beforeString1 . "\E(.*?)\Q" . afterString1 . "\E", res)
	Return res1
}

GetInfoArray(platform) {
	static counter = 0, FailCount = 0
	counter++

	If isOnline() {
		Loop {
			Try html := GetWebData(platform)
			version := ""
			version := round(trim(FoundFirstPos(html, "version=""", """")),0)
			(!version) || (platform = "Twitch") ? version := platform
			If (platform = 1) {
				;msgbox, %platform% - %version%`n%html%
				FormatTime, timestamp, , yyyyMMddHHmmss
				f := timestamp . platform . ".txt"
				hf := StrReplace(html, "><", ">`n<")
				FileAppend, %hf% , %f%
			}
			Switch version {
				Case "1":							RSSdata := ExHTMLcodeXML1(html, platform)
				Case "2":   						RSSdata := ExHTMLcodeXML2(html, platform)
				Case "Twitch":						RSSdata := ExHTMLcodeTwitch(html)
				Case "Instagram", "Instagram2": 	RSSdata := ExHTMLcodeInstagram(html, platform)
			}

			If (RSSdata["TITLE"] && RSSdata["URL"]) {
				Break
			} Else {
				If (DEV) {
					FailCount++
					If (FailCount >=3 ) {
						; ComObjCreate("SAPI.SpVoice").Speak("Fail: " . FailCount . " Ich gebe auf " . platform . " auf.")
	                    RSSdata := {TITLE: "Temporary not available", URL: false}
                        FailCount := 0
						Break
					}
					Else {
						; ComObjCreate("SAPI.SpVoice").Speak("Auf " . platform . " nichts Gefunden. Fail: " . FailCount . "Ich versuche es noch einmal.")
						Sleep, 5000
					}
				}
			}
		}

	} Else
		Return [0, 0, 1]

	If (RSSdata["TITLE"] = "Temporary not available")
		Return

	InHistory := IsInHistory(RSSdata["URL"], RSSdata["TITLE"])

	If (InfoArray[platform]["URL"] != RSSdata["URL"]) {
		((InfoArray[platform]["URL"] != -1) && !InHistory) ? InfoArray[platform]["NewPost"] := 1
		(!InHistory) ? IntoHistory(RSSdata["URL"], RSSdata["TITLE"])
		InfoArray[platform]["HTITLE"] := InfoArray[platform]["TITLE"]
	}

	InfoArray[platform]["TITLE"] := ClearStr(RSSdata["TITLE"])
	InfoArray[platform]["URL"] := RSSdata["URL"]
}

GetShortMenuTitle(platform) {
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

GetWebData(platform, url="") {
	(!url) ? url := InfoArray[platform]["RSS"]
	Page := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	Page.Open("GET", url, true)
	Page.Send()
	Page.WaitForResponse()
	If (1 = 0) {
        FormatTime, timestamp, , yyyyMMddHHmmss
		f := timestamp . platform . ".txt"
		html := Page.ResponseText
		; hf := StrReplace(html, "><", ">`n<")
		FileAppend, %html% , %f%
	}
	Return Page.ResponseText
}

IntoHistory(URL, Title = "") {
	(URL == "https://www.twitch.tv/readyx") ? URL := URL . Title
    FileAppend, %URL%`n, %tf%history.txt
}

IsInHistory(URL, Title = "") {
	If !FileExist(tf . "history.txt")
		Return False
	(URL == "https://www.twitch.tv/readyx") ? URL := URL . Title
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

IsOnline() {
	RunWait, %ComSpec% /c ping -n 1 1.1.1.1 ,, Hide UseErrorLevel
	Return !ErrorLevel
}

OpenLink(bt, bno, sm, url="") {
	Loop, % pArray.Length() {
		platform := pArray[A_Index]
		If  (sm = "Tray") && (GetShortMenuTitle(platform) == bt) {
			InfoArray[platform]["NewPost"] := 0
            Menu, Tray, Icon, % GetShortMenuTitle(platform), %TF%%platform%-16icon.png,, 0
			If (NewPostCount) {
				TT := (NewPostCount < 2) ? " - Neuer Beitrag" : " - Neue Beiträge"
				Menu, Tray, Icon, %ICO2%, 0
			} Else
                Menu, Tray, Icon, %ICO%, 0
			url := InfoArray[platform]["URL"]
			Break
		}
		If (sm = "webportals") && (platform == bt) {
			url := InfoArray[platform]["CURL"]
			Break
		}
	}
	If (!url) {
		Loop, % StaticLinks.length() {
        	If  (StaticLinks[A_Index]["TITLE"] == bt) {
				url := StaticLinks[A_Index]["URL"]
				Break
			}
		}
	}

	If (bt = RUNONSTARTUP) {
		SetAutoStart()
		Return
	}


	If (bt = UPDATEBUTTONTITLE) {
		CheckAPPUpdate(1)
		Return
	}

	If (bt = UntagNewPost) {
        UntagNewPost()
		Return
	}

	If (bt = Voicemenu) {
        Voice()
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

	SetToolTipIcon()

	If url
		Run, %url%
}

RefreshMenu(b=0) {
	Static a
	ONLINE := isOnline()

	If ONLINE && !a {
        Loop, % pArray.Length()
	    	If (InfoArray[pArray[A_Index]]["STATE"])
				Menu, Tray, Enable, % InfoArray[pArray[A_Index]]["BHTITLE"]
		;Menu, Tray, Enable, %SUBMENUNAME%
		;Menu, Tray, Enable, Etsy Store
		;Menu, Tray, Enable, Discord
		;Menu, %GHSUB%, Enable, %AppName% - GitHub
		;Menu, Tray, Enable, %COMHOME%
        (DEV || Voice) ? ComObjCreate("SAPI.SpVoice").Speak("Online")
        (!b) ? Check4Updates()
		SetTimer, %fnCheck4Updates%, 300000
		a := true
	}
	If !ONLINE && (a || b) {
        Loop, % pArray.Length()
	    	If (InfoArray[pArray[A_Index]]["STATE"])
				Menu, Tray, Disable, % InfoArray[pArray[A_Index]]["BHTITLE"]
		;Menu, Tray, Disable, %SUBMENUNAME%
		;Menu, Tray, Disable, Etsy Store
		;Menu, Tray, Disable, Discord
		;Menu, %GHSUB%, Disable, %AppName% - GitHub
		;Menu, Tray, Disable, %COMHOME%
        (DEV || Voice) ? ComObjCreate("SAPI.SpVoice").Speak("Offline")
		SetTimer, %fnCheck4Updates%, Off
		a := false
	}
}

SetAutoStart() {
	If FileExist(A_Startup . "\" . AppName . ".lnk")
    	FileDelete, %A_Startup%\%AppName%.lnk
	Else
    	FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%AppName%.lnk
	StartUp()
}

SetTemp() {
    If !FileExist(TF)
		FileCreateDir, %TF%
	If !FileExist(ICO)
		FileInstall, ReadyxChalloBingBong-16icon.png, %ICO%, 1
	If !FileExist(PathToSplashImage)
		FileInstall, splash.png, %PathToSplashImage%, 1
	iconArray := ["Instagram", "nInstagram", "Tiktok", "nTiktok", "Twitch", "nTwitch", "Twitter", "nTwitter", "YouTube", "nYouTube", "BlueDot", "nBlueDot", "ReadyxChalloBingBong-16icon", "nReadyxChalloBingBong-16icon"]
	Loop, % iconArray.length() {
		filename := iconArray[A_Index]
		pathto := TF . iconArray[A_Index] . "-16icon.png"
		If !FileExist(pathto) {
			Switch filename {
				Case "Instagram":
						FileInstall, Instagram-16icon.png, %pathto%, 1
				Case "nInstagram":
						FileInstall, nInstagram-16icon.png, %pathto%, 1
				Case "Tiktok":
						FileInstall, Tiktok-16icon.png, %pathto%, 1
				Case "nTiktok":
						FileInstall, nTiktok-16icon.png, %pathto%, 1
				Case "Twitch":
						FileInstall, Twitch-16icon.png, %pathto%, 1
				Case "nTwitch":
						FileInstall, nTwitch-16icon.png, %pathto%, 1
				Case "Twitter":
						FileInstall, Twitter-16icon.png, %pathto%, 1
				Case "nTwitter":
						FileInstall, nTwitter-16icon.png, %pathto%, 1
				Case "YouTube":
						FileInstall, YouTube-16icon.png, %pathto%, 1
				Case "nYouTube":
						FileInstall, nYouTube-16icon.png, %pathto%, 1
				Case "BlueDot":
						FileInstall, BlueDot-16icon.png, %pathto%, 1
				Case "nBlueDot":
						FileInstall, nBlueDot-16icon.png, %pathto%, 1
				Case "ReadyxChalloBingBong-16icon":
						FileInstall, ReadyxChalloBingBong-16icon.png, %pathto%, 1
				Case "nReadyxChalloBingBong-16icon":
						FileInstall, nReadyxChalloBingBong-16icon.png, %pathto%, 1
			}
		}
	}

	FileInstall, version, %TF%version, 1
}

SetToolTipIcon() {
	NewPostCount := 0
	Loop, % pArray.Length()
		If InfoArray[pArray[A_Index]]["NewPost"] {
            platform := pArray[A_Index]
            Menu, Tray, Icon, % InfoArray[platform]["BHTITLE"], %TF%n%platform%-16icon.png,, 0
			NewPostCount++
		}
	TT := "- kein neuer Beitrag"
	If NewPostCount {
		Menu, Tray, Icon, %ICO2%, 0
        TT := (NewPostCount < 2) ? " - " . NewPostCount . " Neuer Beitrag" : " - " . NewPostCount . " Neue Beiträge"
	} Else
		Menu, Tray, Icon, %ICO%, 0

	Menu, Tray, Tip, %AppTooltip% %TT%
}

SplashScreen() {
	If DEV
		Return
  	Gui, Splash: Color, 1a2b3c
	Gui, Splash: +HwndSplashwdHwnd +LastFound +AlwaysOnTop -Caption +ToolWindow
	Gui, Splash: Add, Picture, x0 y0, %PathToSplashImage%
	Gui, Splash: Show, w%SplashPIC_widget_w% h%SplashPIC_widget_h% NA, Power Reminder Splash Screen
	WinSet, TransColor, 1a2b3c, ahk_id %SplashwdHwnd%
}

UntagNewPost() {
	NewPostCount := 0
	Loop, % pArray.Length() {
    	platform := pArray[A_Index]
        InfoArray[platform]["NewPost"] := 0
		Menu, Tray, Icon, % InfoArray[platform]["BHTITLE"], %TF%%platform%-16icon.png,, 0
	}
	Menu, Tray, Icon, %ICO%, 0
	Menu, Tray, Tip, %AppTooltip%
}

StartUp() {
	If FileExist(A_Startup . "\" . AppName . ".lnk")
		Menu, %ROSSUB%, Check, %RUNONSTARTUP%
	Else
		Menu, %ROSSUB%, Uncheck, %RUNONSTARTUP%

	If FileExist(TF . "voicetoken") {
		Voice := True
		Menu, %ROSSUB%, Check, %Voicemenu%
	} Else {
		Voice := False
		Menu, %ROSSUB%, Uncheck, %Voicemenu%
	}
}

Voice() {
	If FileExist(TF . "voicetoken") {
		Voice := False
        ComObjCreate("SAPI.SpVoice").Speak("Voicetoken wird entfernt. Ich bin nun Still.")
        FileDelete, %tf%voicetoken
		Menu, %ROSSUB%, Uncheck, %Voicemenu%
	} Else {
		Voice := True
        ComObjCreate("SAPI.SpVoice").Speak("Voicetoken wird gesetzt. Challo Bing Bong.")
        FileAppend, I can't dance but talk, %tf%voicetoken
		Menu, %ROSSUB%, Check, %Voicemenu%
	}
}

YouTubeRSSFeedURLbuilder() {
	Loop, % pArray.Length() {
		platform := pArray[A_Index]
		If (InStr(InfoArray[platform]["CURL"], "https://www.youtube.com/channel/")) && !InfoArray[platform]["RSS"] {
			cid := StrReplace(InfoArray[platform]["CURL"], "https://www.youtube.com/channel/")
			InfoArray[platform]["RSS"] := "https://www.youtube.com/feeds/videos.xml?channel_id=" . cid
		}
	}
}