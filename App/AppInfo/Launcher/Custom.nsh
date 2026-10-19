; 7-Zip Portable custom code for PortableApps Compiler.
; For support, visit the GitHub project:
; https://github.com/daemondevin/pac-man
;
; What lives here and why:
;   Architecture  One package, three builds: App\7-Zip (x86), App\7-Zip64
;                 (x64) and App\7-ZipARM64 (ARM64). The framework picks the
;                 native one from the ProgramExecutable keys (7zFM.exe, or
;                 7zG.exe when there are parameters); the user can force one
;                 with Architecture= in 7-ZipPortable.ini.
;   Update        Optional self update of all three builds from the official
;                 7-Zip releases on GitHub. The new builds are extracted next
;                 to the old ones first and then swapped in under the
;                 journal, so a failure or a crash keeps the old version.
;   SevenZip      Journaled session changes: the SendTo shortcut and,
;                 optionally, the 7-Zip context menu in Explorer, registered
;                 for the current user only (no administrator rights).
;   Language      PortableApps.com Platform language to 7-Zip's Lang value.
;
; File associations are not done here: they are declared in
; 7-ZipPortable.ini and handled by the journaled Associations segment.

; Variables
Var SevenZipLocal
Var SevenZipLocalText
Var SevenZipMissing
Var SevenZipTag
Var SevenZipRemote
Var SevenZipRemoteText
Var SevenZipFile
Var SevenZipDir
Var SevenZipSwapped
Var SevenZipTool
Var SevenZipSuffix
Var SevenZipLabel
Var SevenZipFailed
Var SevenZipBanner

; Defines
!define APPARM64    `7-ZipARM64`
!define REG         `${SET}\${APP}.reg`
!define DEFREG      `${DEFSET}\${APP}.reg`
!define LANG        HKEY_CURRENT_USER\Software\7-Zip
!define KEY         Lang
!define GUID        {23170F69-40C1-278A-1000-000100020000}
!define SND         `$SENDTO\${APP}.lnk`
!define PFM         `$0\PortableApps.com\PortableAppsPlatform.exe`
!define CURL        `$SYSDIR\curl.exe`
!define RELEASES    `https://github.com/ip7z/7zip/releases`
!define API         `https://api.github.com/repos/ip7z/7zip/releases/latest`
!define UPD         `$PLUGINSDIR\7zupdate`
!define /ifndef IMAGE_FILE_MACHINE_ARM64 0xAA64
!define /ifndef SHCNE_ASSOCCHANGED 0x08000000

; Functions

; Language: the platform's LCID to 7-Zip's Lang code and back.
Function GetLCID
	!macro _GetLCID _LNG _LCID
		Push ${_LNG}
		Call GetLCID
		Pop ${_LCID}
	!macroend
	!define GetLCID "!insertmacro _GetLCID"
	Exch $0
	StrCmpS $0 af 0 +3
	StrCpy $0 1078
		Goto EndLCID
	StrCmpS $0 an 0 +3
	StrCpy $0 8888
		Goto EndLCID
	StrCmpS $0 ast 0 +3
	StrCpy $0 8887
		Goto EndLCID
	StrCmpS $0 az 0 +3
	StrCpy $0 1068
		Goto EndLCID
	StrCmpS $0 ba 0 +3
	StrCpy $0 1133
		Goto EndLCID
	StrCmpS $0 be 0 +3
	StrCpy $0 1059
		Goto EndLCID
	StrCmpS $0 bg 0 +3
	StrCpy $0 1026
		Goto EndLCID
	StrCmpS $0 bn 0 +3
	StrCpy $0 8886
		Goto EndLCID
	StrCmpS $0 br 0 +3
	StrCpy $0 1150
		Goto EndLCID
	StrCmpS $0 ca 0 +3
	StrCpy $0 1027
		Goto EndLCID
	StrCmpS $0 co 0 +3
	StrCpy $0 1155
		Goto EndLCID
	StrCmpS $0 cs 0 +3
	StrCpy $0 1029
		Goto EndLCID
	StrCmpS $0 cy 0 +3
	StrCpy $0 1106
		Goto EndLCID
	StrCmpS $0 da 0 +3
	StrCpy $0 1030
		Goto EndLCID
	StrCmpS $0 de 0 +3
	StrCpy $0 1031
		Goto EndLCID
	StrCmpS $0 el 0 +3
	StrCpy $0 1032
		Goto EndLCID
	StrCmpS $0 - 0 +3
	StrCpy $0 1033
		Goto EndLCID
	StrCmpS $0 eo 0 +3
	StrCpy $0 9998
		Goto EndLCID
	StrCmpS $0 es 0 +3
	StrCpy $0 1034
		Goto EndLCID
	StrCmpS $0 et 0 +3
	StrCpy $0 1061
		Goto EndLCID
	StrCmpS $0 eu 0 +3
	StrCpy $0 1069
		Goto EndLCID
	StrCmpS $0 ext 0 +3
	StrCpy $0 8885
		Goto EndLCID
	StrCmpS $0 fa 0 +3
	StrCpy $0 1065
		Goto EndLCID
	StrCmpS $0 fi 0 +3
	StrCpy $0 1035
		Goto EndLCID
	StrCmpS $0 fr 0 +3
	StrCpy $0 1036
		Goto EndLCID
	StrCmpS $0 fur 0 +3
	StrCpy $0 8884
		Goto EndLCID
	StrCmpS $0 fy 0 +3
	StrCpy $0 1122
		Goto EndLCID
	StrCmpS $0 ga 0 +3
	StrCpy $0 2108
		Goto EndLCID
	StrCmpS $0 gl 0 +3
	StrCpy $0 1110
		Goto EndLCID
	StrCmpS $0 gu 0 +3
	StrCpy $0 1095
		Goto EndLCID
	StrCmpS $0 he 0 +3
	StrCpy $0 1037
		Goto EndLCID
	StrCmpS $0 hi 0 +3
	StrCpy $0 1081
		Goto EndLCID
	StrCmpS $0 hr 0 +3
	StrCpy $0 1050
		Goto EndLCID
	StrCmpS $0 hu 0 +3
	StrCpy $0 1038
		Goto EndLCID
	StrCmpS $0 hy 0 +3
	StrCpy $0 1067
		Goto EndLCID
	StrCmpS $0 id 0 +3
	StrCpy $0 1057
		Goto EndLCID
	StrCmpS $0 io 0 +3
	StrCpy $0 8883
		Goto EndLCID
	StrCmpS $0 is 0 +3
	StrCpy $0 1039
		Goto EndLCID
	StrCmpS $0 it 0 +3
	StrCpy $0 1040
		Goto EndLCID
	StrCmpS $0 ja 0 +3
	StrCpy $0 1041
		Goto EndLCID
	StrCmpS $0 ka 0 +3
	StrCpy $0 1079
		Goto EndLCID
	StrCmpS $0 kaa 0 +3
	StrCpy $0 8882
		Goto EndLCID
	StrCmpS $0 kk 0 +3
	StrCpy $0 1087
		Goto EndLCID
	StrCmpS $0 ko 0 +3
	StrCpy $0 1042
		Goto EndLCID
	StrCmpS $0 ku 0 +3
	StrCpy $0 9999
		Goto EndLCID
	StrCmpS $0 ku-ckb 0 +3
	StrCpy $0 8881
		Goto EndLCID
	StrCmpS $0 ky 0 +3
	StrCpy $0 1088
		Goto EndLCID
	StrCmpS $0 lij 0 +3
	StrCpy $0 8880
		Goto EndLCID
	StrCmpS $0 lt 0 +3
	StrCpy $0 1063
		Goto EndLCID
	StrCmpS $0 lv 0 +3
	StrCpy $0 1062
		Goto EndLCID
	StrCmpS $0 mk 0 +3
	StrCpy $0 1071
		Goto EndLCID
	StrCmpS $0 mn 0 +3
	StrCpy $0 1104
		Goto EndLCID
	StrCmpS $0 mng 0 +3
	StrCpy $0 1104
		Goto EndLCID
	StrCmpS $0 mng2 0 +3
	StrCpy $0 1104
		Goto EndLCID
	StrCmpS $0 mr 0 +3
	StrCpy $0 1102
		Goto EndLCID
	StrCmpS $0 ms 0 +3
	StrCpy $0 1086
		Goto EndLCID
	StrCmpS $0 nb 0 +3
	StrCpy $0 1044
		Goto EndLCID
	StrCmpS $0 ne 0 +3
	StrCpy $0 1121
		Goto EndLCID
	StrCmpS $0 nl 0 +3
	StrCpy $0 1043
		Goto EndLCID
	StrCmpS $0 nn 0 +3
	StrCpy $0 2068
		Goto EndLCID
	StrCmpS $0 pa-in 0 +3
	StrCpy $0 1094
		Goto EndLCID
	StrCmpS $0 pl 0 +3
	StrCpy $0 1045
		Goto EndLCID
	StrCmpS $0 ps 0 +3
	StrCpy $0 1123
		Goto EndLCID
	StrCmpS $0 pt 0 +3
	StrCpy $0 2070
		Goto EndLCID
	StrCmpS $0 pt-br 0 +3
	StrCpy $0 1046
		Goto EndLCID
	StrCmpS $0 ro 0 +3
	StrCpy $0 1048
		Goto EndLCID
	StrCmpS $0 ru 0 +3
	StrCpy $0 1049
		Goto EndLCID
	StrCmpS $0 sa 0 +3
	StrCpy $0 1103
		Goto EndLCID
	StrCmpS $0 si 0 +3
	StrCpy $0 1115
		Goto EndLCID
	StrCmpS $0 sk 0 +3
	StrCpy $0 1051
		Goto EndLCID
	StrCmpS $0 sl 0 +3
	StrCpy $0 1060
		Goto EndLCID
	StrCmpS $0 sq 0 +3
	StrCpy $0 1052
		Goto EndLCID
	StrCmpS $0 sr-spc 0 +3
	StrCpy $0 3098
		Goto EndLCID
	StrCmpS $0 sr-spl 0 +3
	StrCpy $0 2074
		Goto EndLCID
	StrCmpS $0 sv 0 +3
	StrCpy $0 1053
		Goto EndLCID
	StrCmpS $0 ta 0 +3
	StrCpy $0 1097
		Goto EndLCID
	StrCmpS $0 th 0 +3
	StrCpy $0 1054
		Goto EndLCID
	StrCmpS $0 tr 0 +3
	StrCpy $0 1055
		Goto EndLCID
	StrCmpS $0 tt 0 +3
	StrCpy $0 1092
		Goto EndLCID
	StrCmpS $0 ug 0 +3
	StrCpy $0 1152
		Goto EndLCID
	StrCmpS $0 uk 0 +3
	StrCpy $0 1058
		Goto EndLCID
	StrCmpS $0 uz 0 +3
	StrCpy $0 2115
		Goto EndLCID
	StrCmpS $0 va 0 +3
	StrCpy $0 33280
		Goto EndLCID
	StrCmpS $0 vi 0 +3
	StrCpy $0 1066
		Goto EndLCID
	StrCmpS $0 zh-cn 0 +3
	StrCpy $0 2052
		Goto EndLCID
	StrCmpS $0 zh-tw 0 +3
	StrCpy $0 1028
		Goto +2
	StrCpy $0 1033
	EndLCID:
	Exch $0
FunctionEnd
Function GetLNG
	!macro _GetLNG _LCID _LNG
		Push ${_LCID}
		Call GetLNG
		Pop ${_LNG}
	!macroend
	!define GetLNG "!insertmacro _GetLNG"
	Exch $0
	StrCmpS $0 1078 0 +3
	StrCpy $0 af
		Goto EndLNG
	StrCmpS $0 8888 0 +3
	StrCpy $0 an
		Goto EndLNG
	StrCmpS $0 8887 0 +3
	StrCpy $0 ast
		Goto EndLNG
	StrCmpS $0 1068 0 +3
	StrCpy $0 az
		Goto EndLNG
	StrCmpS $0 1133 0 +3
	StrCpy $0 ba
		Goto EndLNG
	StrCmpS $0 1059 0 +3
	StrCpy $0 be
		Goto EndLNG
	StrCmpS $0 1026 0 +3
	StrCpy $0 bg
		Goto EndLNG
	StrCmpS $0 8886 0 +3
	StrCpy $0 bn
		Goto EndLNG
	StrCmpS $0 1150 0 +3
	StrCpy $0 br
		Goto EndLNG
	StrCmpS $0 1027 0 +3
	StrCpy $0 ca
		Goto EndLNG
	StrCmpS $0 1155 0 +3
	StrCpy $0 co
		Goto EndLNG
	StrCmpS $0 1029 0 +3
	StrCpy $0 cs
		Goto EndLNG
	StrCmpS $0 1106 0 +3
	StrCpy $0 cy
		Goto EndLNG
	StrCmpS $0 1030 0 +3
	StrCpy $0 da
		Goto EndLNG
	StrCmpS $0 1031 0 +3
	StrCpy $0 de
		Goto EndLNG
	StrCmpS $0 1032 0 +3
	StrCpy $0 el
		Goto EndLNG
	StrCmpS $0 1033 0 +3
	StrCpy $0 -
		Goto EndLNG
	StrCmpS $0 9998 0 +3
	StrCpy $0 eo
		Goto EndLNG
	StrCmpS $0 1034 0 +3
	StrCpy $0 es
		Goto EndLNG
	StrCmpS $0 1061 0 +3
	StrCpy $0 et
		Goto EndLNG
	StrCmpS $0 1069 0 +3
	StrCpy $0 eu
		Goto EndLNG
	StrCmpS $0 8885 0 +3
	StrCpy $0 ext
		Goto EndLNG
	StrCmpS $0 1065 0 +3
	StrCpy $0 fa
		Goto EndLNG
	StrCmpS $0 1035 0 +3
	StrCpy $0 fi
		Goto EndLNG
	StrCmpS $0 1036 0 +3
	StrCpy $0 fr
		Goto EndLNG
	StrCmpS $0 8884 0 +3
	StrCpy $0 fur
		Goto EndLNG
	StrCmpS $0 1122 0 +3
	StrCpy $0 fy
		Goto EndLNG
	StrCmpS $0 2108 0 +3
	StrCpy $0 ga
		Goto EndLNG
	StrCmpS $0 1110 0 +3
	StrCpy $0 gl
		Goto EndLNG
	StrCmpS $0 1095 0 +3
	StrCpy $0 gu
		Goto EndLNG
	StrCmpS $0 1037 0 +3
	StrCpy $0 he
		Goto EndLNG
	StrCmpS $0 1081 0 +3
	StrCpy $0 hi
		Goto EndLNG
	StrCmpS $0 1050 0 +3
	StrCpy $0 hr
		Goto EndLNG
	StrCmpS $0 1038 0 +3
	StrCpy $0 hu
		Goto EndLNG
	StrCmpS $0 1067 0 +3
	StrCpy $0 hy
		Goto EndLNG
	StrCmpS $0 1057 0 +3
	StrCpy $0 id
		Goto EndLNG
	StrCmpS $0 8883 0 +3
	StrCpy $0 io
		Goto EndLNG
	StrCmpS $0 1039 0 +3
	StrCpy $0 is
		Goto EndLNG
	StrCmpS $0 1040 0 +3
	StrCpy $0 it
		Goto EndLNG
	StrCmpS $0 1041 0 +3
	StrCpy $0 ja
		Goto EndLNG
	StrCmpS $0 1079 0 +3
	StrCpy $0 ka
		Goto EndLNG
	StrCmpS $0 8882 0 +3
	StrCpy $0 kaa
		Goto EndLNG
	StrCmpS $0 1087 0 +3
	StrCpy $0 kk
		Goto EndLNG
	StrCmpS $0 1042 0 +3
	StrCpy $0 ko
		Goto EndLNG
	StrCmpS $0 9999 0 +3
	StrCpy $0 ku
		Goto EndLNG
	StrCmpS $0 8881 0 +3
	StrCpy $0 ku-ckb
		Goto EndLNG
	StrCmpS $0 1088 0 +3
	StrCpy $0 ky
		Goto EndLNG
	StrCmpS $0 8880 0 +3
	StrCpy $0 lij
		Goto EndLNG
	StrCmpS $0 1063 0 +3
	StrCpy $0 lt
		Goto EndLNG
	StrCmpS $0 1062 0 +3
	StrCpy $0 lv
		Goto EndLNG
	StrCmpS $0 1071 0 +3
	StrCpy $0 mk
		Goto EndLNG
	StrCmpS $0 1104 0 +3
	StrCpy $0 mn
		Goto EndLNG
	StrCmpS $0 1102 0 +3
	StrCpy $0 mr
		Goto EndLNG
	StrCmpS $0 1086 0 +3
	StrCpy $0 ms
		Goto EndLNG
	StrCmpS $0 1044 0 +3
	StrCpy $0 nb
		Goto EndLNG
	StrCmpS $0 1121 0 +3
	StrCpy $0 ne
		Goto EndLNG
	StrCmpS $0 1043 0 +3
	StrCpy $0 nl
		Goto EndLNG
	StrCmpS $0 2068 0 +3
	StrCpy $0 nn
		Goto EndLNG
	StrCmpS $0 1094 0 +3
	StrCpy $0 pa-in
		Goto EndLNG
	StrCmpS $0 1045 0 +3
	StrCpy $0 pl
		Goto EndLNG
	StrCmpS $0 1123 0 +3
	StrCpy $0 ps
		Goto EndLNG
	StrCmpS $0 2070 0 +3
	StrCpy $0 pt
		Goto EndLNG
	StrCmpS $0 1046 0 +3
	StrCpy $0 pt-br
		Goto EndLNG
	StrCmpS $0 1048 0 +3
	StrCpy $0 ro
		Goto EndLNG
	StrCmpS $0 1049 0 +3
	StrCpy $0 ru
		Goto EndLNG
	StrCmpS $0 1103 0 +3
	StrCpy $0 sa
		Goto EndLNG
	StrCmpS $0 1115 0 +3
	StrCpy $0 si
		Goto EndLNG
	StrCmpS $0 1051 0 +3
	StrCpy $0 sk
		Goto EndLNG
	StrCmpS $0 1060 0 +3
	StrCpy $0 sl
		Goto EndLNG
	StrCmpS $0 1052 0 +3
	StrCpy $0 sq
		Goto EndLNG
	StrCmpS $0 3098 0 +3
	StrCpy $0 sr-spc
		Goto EndLNG
	StrCmpS $0 2074 0 +3
	StrCpy $0 sr-spl
		Goto EndLNG
	StrCmpS $0 1053 0 +3
	StrCpy $0 sv
		Goto EndLNG
	StrCmpS $0 1097 0 +3
	StrCpy $0 ta
		Goto EndLNG
	StrCmpS $0 1054 0 +3
	StrCpy $0 th
		Goto EndLNG
	StrCmpS $0 1055 0 +3
	StrCpy $0 tr
		Goto EndLNG
	StrCmpS $0 1092 0 +3
	StrCpy $0 tt
		Goto EndLNG
	StrCmpS $0 1152 0 +3
	StrCpy $0 ug
		Goto EndLNG
	StrCmpS $0 1058 0 +3
	StrCpy $0 uk
		Goto EndLNG
	StrCmpS $0 2115 0 +3
	StrCpy $0 uz
		Goto EndLNG
	StrCmpS $0 33280 0 +3
	StrCpy $0 va
		Goto EndLNG
	StrCmpS $0 1066 0 +3
	StrCpy $0 vi
		Goto EndLNG
	StrCmpS $0 2052 0 +3
	StrCpy $0 zh-cn
		Goto EndLNG
	StrCmpS $0 1028 0 +3
	StrCpy $0 zh-tw
		Goto +2
	StrCpy $0 error
	EndLNG:
	Exch $0
FunctionEnd
Function PAL:LanguageLCID
	IfFileExists `${REG}` 0 +3
	ReadINIStr $0 `${REG}` `${LANG}` `"${KEY}"`
	Goto +2
	ReadINIStr $0 `${DEFREG}` `${LANG}` `"${KEY}"`
	${GetLCID} $0 $0
	${SetEnvironmentVariable} PAL:LanguageLCID $0
FunctionEnd

; Architecture

; Picks the build to run. The framework has already worked out the
; architecture Windows runs on ($Arch: x86, x64 or arm64) and will pick the
; matching [Launch] executable from it, falling back to the next build when
; one is missing. Here the user's Architecture= setting (auto, x86, x64 or
; arm64) can override $Arch, and $App, %7-ZIP% and the registry view are kept
; in step with the build that will actually run.
Function SevenZip_SelectArch
	Push $0
	${ReadUserConfig} $0 Architecture
	${If} $0 == x86
		StrCpy $Arch x86
	${ElseIf} $0 == x64
	${AndIf} $Bit == 64
		StrCpy $Arch x64
	${ElseIf} $0 == arm64
	${AndIf} $Arch == arm64
		; Only on ARM64 Windows: nothing else can run the ARM64 build.
		StrCpy $Arch arm64
	${EndIf}
	${If} $Arch == arm64
	${AndIf} ${FileExists} `$EXEDIR\App\${APPARM64}\7zFM.exe`
		StrCpy $App ${APPARM64}
	${ElseIf} $Arch != x86
	${AndIf} ${FileExists} `$EXEDIR\App\${APP64}\7zFM.exe`
		StrCpy $App ${APP64}
	${Else}
		StrCpy $App ${APP}
	${EndIf}
	${If} $App == ${APP}
		SetRegView lastused
	${EndIf}
	System::Call `kernel32::SetEnvironmentVariable(t "7-ZIP", t "$App")`
	Pop $0
FunctionEnd

; Update helpers

; Runs the function _FUNC once per build, with $SevenZipDir, $SevenZipSuffix
; (the release file's suffix) and $SevenZipLabel set for it.
!define SevenZip::EachBuild "!insertmacro _SevenZip::EachBuild"
!macro _SevenZip::EachBuild _FUNC
	StrCpy $SevenZipDir ${APP}
	StrCpy $SevenZipSuffix ""
	StrCpy $SevenZipLabel x86
	Call ${_FUNC}
	StrCpy $SevenZipDir ${APP64}
	StrCpy $SevenZipSuffix -x64
	StrCpy $SevenZipLabel x64
	Call ${_FUNC}
	StrCpy $SevenZipDir ${APPARM64}
	StrCpy $SevenZipSuffix -arm64
	StrCpy $SevenZipLabel ARM64
	Call ${_FUNC}
!macroend

; Shows the banner, or changes its text, to $0.
Function SevenZip_Banner
	Push $1
	${If} $SevenZipBanner == ""
		Banner::show ""
		Banner::getWindow
		Pop $SevenZipBanner
	${EndIf}
	GetDlgItem $1 $SevenZipBanner 1030
	SendMessage $1 ${WM_SETTEXT} 0 "STR:$0"
	Pop $1
FunctionEnd

Function SevenZip_BannerClose
	${If} $SevenZipBanner != ""
		Banner::destroy
		StrCpy $SevenZipBanner ""
	${EndIf}
FunctionEnd

; Sets $1 to the version of the build in $SevenZipDir as major * 100 + minor
; (2604 for 26.04), or 0 when the build isn't there.
Function SevenZip_BuildVersion
	Push $R0
	Push $R1
	Push $R2
	StrCpy $1 0
	${If} ${FileExists} `$EXEDIR\App\$SevenZipDir\7zFM.exe`
		ClearErrors
		GetDllVersion `$EXEDIR\App\$SevenZipDir\7z.dll` $R0 $R1
		${IfNot} ${Errors}
			IntOp $R2 $R0 / 0x00010000
			IntOp $R0 $R0 & 0x0000FFFF
			IntOp $1 $R2 * 100
			IntOp $1 $1 + $R0
		${EndIf}
	${EndIf}
	Pop $R2
	Pop $R1
	Pop $R0
FunctionEnd

; Notes the lowest version across the builds in $SevenZipLocal and the
; missing builds in $SevenZipMissing.
Function SevenZip_CheckBuild
	Push $1
	Call SevenZip_BuildVersion
	${If} $1 = 0
		${If} $SevenZipMissing == ""
			StrCpy $SevenZipMissing $SevenZipLabel
		${Else}
			StrCpy $SevenZipMissing `$SevenZipMissing, $SevenZipLabel`
		${EndIf}
	${ElseIf} $1 < $SevenZipLocal
		StrCpy $SevenZipLocal $1
	${EndIf}
	Pop $1
FunctionEnd

; Sets $0 to version number $0 (major * 100 + minor) as 7-Zip writes it.
Function SevenZip_VersionText
	Push $1
	Push $2
	IntOp $1 $0 / 100
	IntOp $2 $0 % 100
	${If} $2 < 10
		StrCpy $0 `$1.0$2`
	${Else}
		StrCpy $0 `$1.$2`
	${EndIf}
	Pop $2
	Pop $1
FunctionEnd

; Reads $SevenZipTag ("26.04") into $SevenZipRemote (2604), $SevenZipRemoteText
; ("26.04") and $SevenZipFile ("7z2604", the release files' base name).
; $SevenZipRemote is 0 when the tag isn't a 7-Zip version. Digits are added
; up one at a time, because IntOp reads "04" as octal and "09" as nothing.
Function SevenZip_ParseTag
	Push $0
	Push $1
	Push $2
	Push $3
	Push $4
	StrCpy $SevenZipRemote 0
	StrCpy $1 0
	StrCpy $2 ""
	StrCpy $3 ""
	StrCpy $4 0
	${Do}
		StrCpy $0 $SevenZipTag 1 $1
		${IfThen} $0 == "" ${|} ${ExitDo} ${|}
		${If} $0 == "."
		${AndIf} $4 = 0
		${AndIf} $2 != ""
			StrCpy $4 1
		${ElseIf} $0 S>= 0
		${AndIf} $0 S<= 9
			${If} $4 = 0
				${If} $2 == ""
					StrCpy $2 0
				${EndIf}
				IntOp $2 $2 * 10
				IntOp $2 $2 + $0
			${Else}
				${If} $3 == ""
					StrCpy $3 0
				${EndIf}
				IntOp $3 $3 * 10
				IntOp $3 $3 + $0
			${EndIf}
		${Else}
			StrCpy $3 ""
			${ExitDo}
		${EndIf}
		IntOp $1 $1 + 1
	${Loop}
	${If} $2 != ""
	${AndIf} $3 != ""
	${AndIf} $3 < 100
		IntOp $SevenZipRemote $2 * 100
		IntOp $SevenZipRemote $SevenZipRemote + $3
		StrCpy $0 $SevenZipRemote
		Call SevenZip_VersionText
		StrCpy $SevenZipRemoteText $0
		${WordReplace} $SevenZipRemoteText "." "" "+" $0
		StrCpy $SevenZipFile `7z$0`
	${EndIf}
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0
FunctionEnd

; Sets $SevenZipTag to the latest release's tag, or "". The release page
; redirects to the tag, which costs nothing and has no rate limit; the
; GitHub API is the fallback.
Function SevenZip_LatestTag
	Push $0
	Push $1
	Push $2
	StrCpy $SevenZipTag ""
	nsExec::Exec `"${CURL}" -fsSI -o "${UPD}\headers.txt" "${RELEASES}/latest"`
	Pop $0
	ClearErrors
	FileOpen $0 `${UPD}\headers.txt` r
	${IfNot} ${Errors}
		${Do}
			ClearErrors
			FileRead $0 $1
			${IfThen} ${Errors} ${|} ${ExitDo} ${|}
			; == ignores case, and HTTP/2 headers are lower case.
			StrCpy $2 $1 9
			${If} $2 == "location:"
				${WordFind} $1 "/tag/" "E+1}" $2
				${IfNot} ${Errors}
					${Trim} $SevenZipTag $2
				${EndIf}
			${EndIf}
		${Loop}
		FileClose $0
	${EndIf}
	${If} $SevenZipTag == ""
		nsExec::Exec `"${CURL}" -fsSL -H "Accept: application/vnd.github+json" -o "${UPD}\release.json" "${API}"`
		Pop $0
		ClearErrors
		FileOpen $0 `${UPD}\release.json` r
		${IfNot} ${Errors}
			${Do}
				ClearErrors
				FileRead $0 $1
				${IfThen} ${Errors} ${|} ${ExitDo} ${|}
				${WordFind} $1 `"tag_name"` "E+1}" $2
				${IfNot} ${Errors}
					; $2 is now `: "26.04",` plus the line end.
					${WordFind} $2 `"` "E+2" $1
					${IfNot} ${Errors}
						StrCpy $SevenZipTag $1
					${EndIf}
					${ExitDo}
				${EndIf}
			${Loop}
			FileClose $0
		${EndIf}
	${EndIf}
	Pop $2
	Pop $1
	Pop $0
FunctionEnd

Function SevenZip_Download
	${IfThen} $SevenZipFailed != "" ${|} Return ${|}
	Push $0
	Push $1
	StrCpy $1 `$SevenZipFile$SevenZipSuffix.exe`
	StrCpy $0 `Downloading 7-Zip $SevenZipRemoteText ($SevenZipLabel)..`
	Call SevenZip_Banner
	nsExec::Exec `"${CURL}" -fsSL -o "${UPD}\$1" "${RELEASES}/download/$SevenZipTag/$1"`
	Pop $0
	${If} $0 <> 0
	${OrIfNot} ${FileExists} `${UPD}\$1`
		StrCpy $SevenZipFailed "The $SevenZipLabel download failed."
	${EndIf}
	Pop $1
	Pop $0
FunctionEnd

; The release files are 7-Zip installers, which 7-Zip itself can open as
; archives. Each build is extracted next to the current one, into
; <build>-new, so nothing in use is touched yet.
Function SevenZip_Extract
	${IfThen} $SevenZipFailed != "" ${|} Return ${|}
	Push $0
	Push $1
	StrCpy $1 `$EXEDIR\App\$SevenZipDir-new`
	RMDir /r $1
	nsExec::Exec `"$SevenZipTool\7z.exe" x "${UPD}\$SevenZipFile$SevenZipSuffix.exe" -o"$1" -y -x!Uninstall.exe`
	Pop $0
	${If} $0 <> 0
	${OrIfNot} ${FileExists} `$1\7zFM.exe`
	${OrIfNot} ${FileExists} `$1\7z.dll`
		StrCpy $SevenZipFailed "The $SevenZipLabel build could not be extracted (7-Zip exit code $0)."
	${EndIf}
	Pop $1
	Pop $0
FunctionEnd

Function SevenZip_DropNew
	RMDir /r `$EXEDIR\App\$SevenZipDir-new`
FunctionEnd

Function SevenZip_DropBackup
	RMDir /r `$EXEDIR\App\$SevenZipDir-backup`
FunctionEnd

; Swaps <build>-new in. Moving the current build aside is the backup, and it
; is journaled straight away, so from here on a failure or a crash puts it
; back: the undo deletes the new build and moves the backup into place. A
; build that wasn't there before is journaled with no backup, so the undo
; simply removes it.
Function SevenZip_Swap
	${IfThen} $SevenZipFailed != "" ${|} Return ${|}
	Push $0
	StrCpy $0 `$EXEDIR\App\$SevenZipDir`
	${If} ${FileExists} `$0\*.*`
		ClearErrors
		Rename $0 `$0-backup`
		${If} ${Errors}
			StrCpy $SevenZipFailed "The $SevenZipLabel build is in use and can't be replaced right now. Close every 7-Zip window (Explorer can hold on to the context menu DLL for a while) and try again."
			Pop $0
			Return
		${EndIf}
		${Journal::Record} 7ZipUpdate DIR $0 `$0-backup` recursive ""
	${Else}
		${Journal::Record} 7ZipUpdate DIR $0 "" recursive ""
	${EndIf}
	IntOp $SevenZipSwapped $SevenZipSwapped + 1
	ClearErrors
	Rename `$0-new` $0
	${If} ${Errors}
		StrCpy $SevenZipFailed "The new $SevenZipLabel build could not be moved into place."
	${EndIf}
	Pop $0
FunctionEnd

; Puts the builds back after an update that was interrupted. Called from the
; InstanceManagement segment before the launcher checks that 7zFM.exe
; exists, and only for a primary launch, so it never touches an update
; another launcher is still doing.
Function SevenZip_RepairBuild
	Push $0
	StrCpy $0 `$EXEDIR\App\$SevenZipDir`
	${If} ${FileExists} `$0-backup\*.*`
		${If} ${FileExists} `$0\7zFM.exe`
			; The update was committed; the old copy is left over.
			RMDir /r `$0-backup`
		${Else}
			; The new build never got in place; put the old one back.
			RMDir /r $0
			Rename `$0-backup` $0
		${EndIf}
	${EndIf}
	RMDir /r `$0-new`
	Pop $0
FunctionEnd

Function SevenZip_Repair
	Push $0
	${Journal::HasEntries} 7ZipUpdate $0
	${If} $0 > 0
		${Journal::Rollback} 7ZipUpdate
	${EndIf}
	${SevenZip::EachBuild} SevenZip_RepairBuild
	Pop $0
FunctionEnd

; Checks for a newer 7-Zip and, if the user agrees, updates all three builds.
; Also offers to download a build the package is missing (ARM64 in packages
; made before it existed).
Function SevenZip_Update
	Push $0
	Push $1
	${ReadUserConfig} $0 UpdateCheck
	${If} $0 != true
		Goto update_done
	${EndIf}
	; An earlier update that could not be undone yet is retried by the
	; journal; don't start another one.
	${Journal::HasEntries} 7ZipUpdate $0
	${If} $0 > 0
		Goto update_done
	${EndIf}

	StrCpy $SevenZipLocal 99999
	StrCpy $SevenZipMissing ""
	${SevenZip::EachBuild} SevenZip_CheckBuild
	${If} $SevenZipLocal = 99999
		StrCpy $SevenZipLocal 0
	${EndIf}
	StrCpy $0 $SevenZipLocal
	Call SevenZip_VersionText
	StrCpy $SevenZipLocalText $0

	InitPluginsDir
	RMDir /r `${UPD}`
	CreateDirectory `${UPD}`
	StrCpy $SevenZipFailed ""
	Call SevenZip_LatestTag
	Call SevenZip_ParseTag
	${If} $SevenZipRemote = 0
		MessageBox MB_ICONSTOP|MB_TOPMOST "Update check failed! Couldn't find out the latest version of 7-Zip.$\r$\n$\r$\nYou need to update ${PORTABLEAPPNAME} manually."
		Goto update_done
	${EndIf}
	${If} $SevenZipRemote <= $SevenZipLocal
	${AndIf} $SevenZipMissing == ""
		Goto update_done
	${EndIf}

	${If} $SevenZipRemote > $SevenZipLocal
	${AndIf} $SevenZipLocal > 0
		StrCpy $0 "A new version of 7-Zip is available: $SevenZipRemoteText (this copy has $SevenZipLocalText)."
		${If} $SevenZipMissing != ""
			StrCpy $0 "$0$\r$\nThe update also adds the $SevenZipMissing build."
		${EndIf}
	${Else}
		StrCpy $0 "${PORTABLEAPPNAME} doesn't have the $SevenZipMissing build of 7-Zip yet. 7-Zip $SevenZipRemoteText can be downloaded now for all three builds."
	${EndIf}
	MessageBox MB_USERICON|MB_YESNO|MB_TOPMOST "$0$\r$\n$\r$\nDo you want to update now?" IDYES +2
	Goto update_done

	; Download all three first: nothing changes if any of them fails.
	${SevenZip::EachBuild} SevenZip_Download
	${If} $SevenZipFailed != ""
		Goto update_failed
	${EndIf}

	; A copy of the current 7z.exe does the extracting, so the folder it
	; lives in can be replaced. The x86 build runs on every Windows.
	StrCpy $0 "Updating 7-Zip. Almost done.."
	Call SevenZip_Banner
	StrCpy $SevenZipTool `${UPD}\tool`
	CreateDirectory $SevenZipTool
	StrCpy $1 ${APP}
	${IfNot} ${FileExists} `$EXEDIR\App\$1\7z.exe`
		StrCpy $1 $App
	${EndIf}
	CopyFiles /SILENT `$EXEDIR\App\$1\7z.exe` $SevenZipTool
	CopyFiles /SILENT `$EXEDIR\App\$1\7z.dll` $SevenZipTool
	${IfNot} ${FileExists} `$SevenZipTool\7z.dll`
		StrCpy $SevenZipFailed "There is no working 7-Zip in the package to extract the update with."
		Goto update_failed
	${EndIf}
	${SevenZip::EachBuild} SevenZip_Extract
	${If} $SevenZipFailed != ""
		${SevenZip::EachBuild} SevenZip_DropNew
		Goto update_failed
	${EndIf}

	StrCpy $SevenZipSwapped 0
	${SevenZip::EachBuild} SevenZip_Swap
	${If} $SevenZipFailed != ""
		${Journal::Rollback} 7ZipUpdate
		${SevenZip::EachBuild} SevenZip_DropNew
		Goto update_failed
	${EndIf}

	; Commit. The entries go first: if the launcher stops before the old
	; copies are deleted, SevenZip_Repair deletes them on the next launch.
	${DoWhile} $SevenZipSwapped > 0
		${Journal::Discard} 7ZipUpdate
		IntOp $SevenZipSwapped $SevenZipSwapped - 1
	${Loop}
	${SevenZip::EachBuild} SevenZip_DropBackup
	${WriteAppInfoConfig} Version PackageVersion `$SevenZipRemoteText.0.0`
	${WriteAppInfoConfig} Version DisplayVersion `$SevenZipRemoteText`
	Call SevenZip_BannerClose
	MessageBox MB_ICONINFORMATION|MB_TOPMOST "7-Zip has been updated to $SevenZipRemoteText.$\r$\n$\r$\nNow launching ${PORTABLEAPPNAME}."
	Goto update_done

	update_failed:
	Call SevenZip_BannerClose
	MessageBox MB_ICONSTOP|MB_TOPMOST "The update failed. $SevenZipFailed$\r$\n$\r$\nThe current version of 7-Zip was kept."

	update_done:
	Call SevenZip_BannerClose
	RMDir /r `${UPD}`
	Pop $1
	Pop $0
FunctionEnd

; Session changes

; Journals HKCU\$1 in registry view $3 ("" or 64), the way ${Journal::RegKey}
; does for keys every view shares. Sets $4 to "" when an existing key could
; not be backed up, so it must not be changed.
Function SevenZip_JournalViewKey
	Push $5
	${Journal::RegKeyExists} HKCU $1 $4
	${If} $4 == 1
		CreateDirectory `${JOURNAL_STORE}\SevenZip`
		StrCpy $5 `${JOURNAL_STORE}\SevenZip\clsid.reg`
		Delete $5
		${If} $3 == 64
			nsExec::ExecToStack `"$SYSDIR\reg.exe" export "HKCU\$1" "$5" /y /reg:64`
		${Else}
			nsExec::ExecToStack `"$SYSDIR\reg.exe" export "HKCU\$1" "$5" /y`
		${EndIf}
		Pop $4
		Pop $4
		${If} ${FileExists} $5
			${Journal::Record} SevenZip REGKEY HKCU $1 $5 $3
			StrCpy $4 existed
		${Else}
			StrCpy $4 ""
		${EndIf}
	${Else}
		${Journal::Record} SevenZip REGKEY HKCU $1 "" $3
		StrCpy $4 new
	${EndIf}
	Pop $5
FunctionEnd

; Writes a shell extension handler key for the 7-Zip menu, journaled.
!define SevenZip::Handler "!insertmacro _SevenZip::Handler"
!macro _SevenZip::Handler _KEY
	${Journal::RegKey} SevenZip HKCU `Software\Classes\${_KEY}\7-Zip` $4
	${If} $4 != ""
		WriteRegStr HKCU `Software\Classes\${_KEY}\7-Zip` "" `${GUID}`
	${EndIf}
!macroend

; The 7-Zip context menu, registered the way 7-Zip's own "integrate into
; the shell context menu" option does it for one user: the shell extension's
; class plus the handler keys for files, folders and drives, all under HKCU.
; ShellExtension=true turns it on; auto turns it on unless an installed
; 7-Zip already provides the menu.
Function SevenZip_ShellExtension
	Push $0
	Push $1
	Push $2
	Push $3
	Push $4
	${ReadUserConfig} $0 ShellExtension
	${If} $0 == auto
		${If} $Bit == 64
			SetRegView 64
		${EndIf}
		ClearErrors
		ReadRegStr $1 HKLM `SOFTWARE\Classes\CLSID\${GUID}\InprocServer32` ""
		${If} $Bit == 64
			SetRegView lastused
		${EndIf}
		${IfNot} ${Errors}
			StrCpy $0 false
		${Else}
			StrCpy $0 true
		${EndIf}
	${EndIf}
	${If} $0 != true
		Goto shell_done
	${EndIf}
	; Explorer loads the DLL, so it has to be Explorer's build: the native
	; one. The x86 build's DLL can't be loaded by a 64-bit Explorer.
	${If} $Bit == 64
	${AndIf} $App == ${APP}
		${DebugMsg} "The x86 build was forced on 64-bit Windows; no context menu."
		Goto shell_done
	${EndIf}
	StrCpy $2 `$EXEDIR\App\$App\7-zip.dll`
	${IfNot} ${FileExists} $2
		Goto shell_done
	${EndIf}

	; The class. HKCU\Software\Classes\CLSID has separate 32-bit and 64-bit
	; views, and this 32-bit launcher has to write Explorer's.
	StrCpy $1 `Software\Classes\CLSID\${GUID}`
	StrCpy $3 ""
	${If} $Bit == 64
		StrCpy $3 64
		SetRegView 64
	${EndIf}
	Call SevenZip_JournalViewKey
	${If} $4 != ""
		WriteRegStr HKCU $1 "" "7-Zip Shell Extension"
		WriteRegStr HKCU `$1\InprocServer32` "" $2
		WriteRegStr HKCU `$1\InprocServer32` ThreadingModel Apartment
	${EndIf}
	${If} $Bit == 64
		SetRegView lastused
	${EndIf}
	${If} $4 == ""
		${DebugMsg} "The 7-Zip shell extension class could not be backed up; no context menu."
		Goto shell_done
	${EndIf}

	; The handlers. These keys are the same in both views.
	${SevenZip::Handler} `*\shellex\ContextMenuHandlers`
	${SevenZip::Handler} `Directory\shellex\ContextMenuHandlers`
	${SevenZip::Handler} `Folder\ShellEx\ContextMenuHandlers`
	${SevenZip::Handler} `Directory\shellex\DragDropHandlers`
	${SevenZip::Handler} `Drive\shellex\DragDropHandlers`
	System::Call `shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i 0, p 0, p 0)`

	shell_done:
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0
FunctionEnd

; The journaled session changes. Every one is recorded before it is made.
Function SevenZip_Apply
	Push $0
	; SendTo shortcut. It opens 7-Zip File Manager directly: it only exists
	; while this session runs, so the portable settings are already loaded,
	; and going through the launcher would hand the file to 7zG.exe (the
	; WhenParameters executable), which needs a command, not just a file.
	SetShellVarContext current
	${Journal::BackupFile} SevenZip `${SND}` $0
	${Journal::Record} SevenZip FILE `${SND}` $0 "" ""
	CreateShortCut `${SND}` `$EXEDIR\App\$App\7zFM.exe` "" `$EXEDIR\App\$App\7zFM.exe` 0
	Call SevenZip_ShellExtension
	Pop $0
FunctionEnd

; Hooks

; InstanceManagement segment, Init, right before 7zFM.exe is looked for.
!macro EXE
	${If} $SecondaryLaunch != true
		Call SevenZip_Repair
	${EndIf}
!macroend

!macro Lang
	${GetParent} `$EXEDIR` $0
	IfFileExists `${PFM}` 0 +6
	ReadEnvStr $0 PAL:LanguageLCID
	Push $0
	Call GetLNG
	Pop $0
	StrCmpS $0 error 0 +2
	Call PAL:LanguageLCID
!macroend

!macro LangInit
	ReadEnvStr $0 PAL:LanguageLCID
	${GetLNG} $0 $0
	${SetEnvironmentVariable} PAL:LanguageCustom $0
!macroend

; Settings segment, Init, primary instance only.
!macro Init
	${Init::File} settings ${APP}.reg
!macroend

${SegmentFile}

${Segment.OnInit}
	Call SevenZip_SelectArch
!macroend

${SegmentPrePrimary}
	; Runs after crash recovery and after the journal session is open.
	Call SevenZip_Update
	; 7-Zip keeps folder history as UTF-16 hex in the saved settings; fix
	; the drive letter there when the package moved to another drive.
	ReadEnvStr $1 PAL:LastDrive
	StrCpy $0 $EXEDIR 2
	${If} $1 != ""
	${AndIf} $0 != $1
	${AndIf} ${FileExists} `${REG}`
		${Registry::StrToHexW} `$0\` $0
		${Registry::StrToHexW} `$1\` $1
		StrCpy $0 $0 2
		StrCpy $1 $1 2
		${ReplaceInFileU16CS} `${REG}` `$1,00,3a` `$0,00,3a`
	${EndIf}
	Call SevenZip_Apply
	${ReadUserConfig} $0 Banner
	${If} $0 == true
		StrCpy $0 $(i)
		Call SevenZip_Banner
	${EndIf}
!macroend

!macro PreExecExecute
	${If} $SecondaryLaunch != true
		Call SevenZip_BannerClose
	${EndIf}
!macroend

${SegmentPostPrimary}
	${Journal::HasEntries} SevenZip $R0
	${If} $R0 > 0
		${Journal::Rollback} SevenZip
		System::Call `shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i 0, p 0, p 0)`
	${EndIf}
!macroend
