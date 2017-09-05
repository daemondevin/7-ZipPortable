
;= LAUNCHER
;= ################
; This PAF was compiled using a modified version of PAL:
; https://github.com/demondevin/portableapps.comlauncher

;= VARIABLES
;= ################
Var            APP

;= DEFINES
;= ################
!define 32     7-Zip\7zFM.exe
!define 64     7-Zip64\7zFM.exe
!define EXE32  `$EXEDIR\App\${32}`
!define EXE64  `$EXEDIR\App\${64}`
!define SET32  `Kernel32::SetEnvironmentVariable(t "7-ZIP", t "7-Zip")`
!define SET64  `Kernel32::SetEnvironmentVariable(t "7-ZIP", t "7-Zip64")`
!define REG    `${SET}\${APP}.reg`
!define DEFREG `${DEFSET}\${APP}.reg`
!define LANG   HKEY_CURRENT_USER\Software\7-Zip
!define FM     ${LANG}\FM
!define KEY    Lang
!define GUID   {23170F69-40C1-278A-1000-000100020000}
!define KEY1   SOFTWARE\Classes\CLSID\${GUID}
!define CLSID  ${KEY1}\InprocServer32
!define DIR1   SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\7-Zip
!define DIR2   SOFTWARE\Classes\Directory\shellex\DragDropHandlers\7-Zip
!define DRV    SOFTWARE\Classes\Drive\shellex\DragDropHandlers\7-Zip
!define FLD    SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\7-Zip
!define SHLX   SOFTWARE\Classes\*\shellex\ContextMenuHandlers\7-Zip
!define VAL1   `7-Zip Shell Extension`
!define CL     SOFTWARE\Classes
!define CLS    HKCU\${CL}
!define HCLS   HKLM\${CL}
!define EX     SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts
!define EXTS   HKCU\Software\Microsoft\Windows\Roaming\OpenWith\FileExts
!define EXT    HKCU\${EX}
!define UC     `${EX}\.$1\UserChoice`
!define R1     `${CL}\${APP}.$1`
!define O      `${R1}\shell\open`
!define D      `${R1}\DefaultIcon`
!define C      `${O}\command`
!define ARC    `$1 Archive`
!define PRO    `$EXEDIR\App\$APP`
!define ICO    `${PRO}\7z.dll`
!define DLL    `${PRO}\7-zip.dll`
!define EXE    `${PRO}\7zFM.exe`
!define SND    `$SENDTO\${APP}.lnk`
!define PFM    `$0\PortableApps.com\PortableAppsPlatform.exe`

;= MACROS
;= ################

;= FUNCTIONS
;= ################
Function GetIconIndex
	!macro _GetIconIndex _TYPE _INDEX
		Push ${_TYPE}
		Call GetIconIndex
		Pop ${_INDEX}
	!macroend
	!define GetIconIndex `!insertmacro _GetIconIndex`
	Exch $0
	StrCmpS $0 001 0 +3
	StrCpy $0 9
		Goto END
	StrCmpS $0 7z 0 +3
	StrCpy $0 0
		Goto END
	StrCmpS $0 arj 0 +3
	StrCpy $0 4
		Goto END
	StrCmpS $0 bz2 0 +3
	StrCpy $0 2
		Goto END
	StrCmpS $0 bzip2 0 +3
	StrCpy $0 2
		Goto END
	StrCmpS $0 cab 0 +3
	StrCpy $0 7
		Goto END
	StrCmpS $0 cpio 0 +3
	StrCpy $0 12
		Goto END
	StrCmpS $0 deb 0 +3
	StrCpy $0 11
		Goto END
	StrCmpS $0 dmg 0 +3
	StrCpy $0 17
		Goto END
	StrCmpS $0 fat 0 +3
	StrCpy $0 21
		Goto END
	StrCmpS $0 gz 0 +3
	StrCpy $0 14
		Goto END
	StrCmpS $0 gzip 0 +3
	StrCpy $0 14
		Goto END
	StrCmpS $0 hfs 0 +3
	StrCpy $0 18
		Goto END
	StrCmpS $0 iso 0 +3
	StrCpy $0 8
		Goto END
	StrCmpS $0 lha 0 +3
	StrCpy $0 6
		Goto END
	StrCmpS $0 lzh 0 +3
	StrCpy $0 6
		Goto END
	StrCmpS $0 lzma 0 +3
	StrCpy $0 16
		Goto END
	StrCmpS $0 ntfs 0 +3
	StrCpy $0 22
		Goto END
	StrCmpS $0 rar 0 +3
	StrCpy $0 3
		Goto END
	StrCmpS $0 rpm 0 +3
	StrCpy $0 10
		Goto END
	StrCmpS $0 squashfs 0 +3
	StrCpy $0 24
		Goto END
	StrCmpS $0 swm 0 +3
	StrCpy $0 15
		Goto END
	StrCmpS $0 tar 0 +3
	StrCpy $0 13
		Goto END
	StrCmpS $0 taz 0 +3
	StrCpy $0 5
		Goto END
	StrCmpS $0 tbz 0 +3
	StrCpy $0 2
		Goto END
	StrCmpS $0 tbz2 0 +3
	StrCpy $0 2
		Goto END
	StrCmpS $0 tgz 0 +3
	StrCpy $0 14
		Goto END
	StrCmpS $0 tpz 0 +3
	StrCpy $0 14
		Goto END
	StrCmpS $0 txz 0 +3
	StrCpy $0 23
		Goto END
	StrCmpS $0 vhd 0 +3
	StrCpy $0 20
		Goto END
	StrCmpS $0 wim 0 +3
	StrCpy $0 15
		Goto END
	StrCmpS $0 xar 0 +3
	StrCpy $0 19
		Goto END
	StrCmpS $0 xz 0 +3
	StrCpy $0 23
		Goto END
	StrCmpS $0 z 0 +3
	StrCpy $0 5
		Goto END
	StrCmpS $0 zip 0 +3
	StrCpy $0 1
		Goto +2
	StrCpy $0 error
	END:
	Exch $0
FunctionEnd
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
	StrCpy $0 1251
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
	StrCmpS $0 1251 0 +3
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
	StrCpy $0 mng
		Goto EndLNG
	StrCmpS $0 1102 0 +3
	StrCpy $0 mng2
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

;= CUSTOM
;= ################
${SegmentFile}
${Segment.OnInit}
	StrCmpS $Bit 32 +6
	IfFileExists `${EXE64}` 0 +5
	SetRegView 64
	StrCpy $APP ${APP64}
	System::Call `${SET64}`
	Goto +3
	StrCpy $APP ${APP}
	System::Call `${SET32}`
!macroend
!macro PostExecWaitCommand
	StrCmpS $SecondaryLaunch true +3
	Push 7zG.exe
	Call CloseX
!macroend
!macro ProExecInit
	StrCpy $ProgramExecutable $App\7zFM.exe
!macroend
Function Elevate
	StrCmpS $SecondaryLaunch true 0 +2
	Return
	StrCpy $RunAsAdmin force
	Elevate:
	!insertmacro UAC_RunElevated
	${Switch} $0
		${Case} 0
			${IfThen} $1 = 1 ${|} Quit ${|}
			${If} $3 <> 0
				${Break}
			${EndIf}
			${If} $1 = 3
				MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION|MB_TOPMOST|MB_SETFOREGROUND \ 
				"$(LauncherRequiresAdmin)$\r$\n$\r$\n$(LauncherNotAdminTryAgain)" IDRETRY Elevate
				Quit
			${EndIf}
		${CaseUACCodeAlert} 1223 \
			"$(LauncherRequiresAdmin)" \
			"$(LauncherNotAdminLimitedFunctionality)"
		${CaseUACCodeAlert} 1062 \
			"$(LauncherAdminLogonServiceNotRunning)" \
			"$(LauncherNotAdminLimitedFunctionality)"
		${CaseUACCodeAlert} "" \
			"$(LauncherAdminError)$\r$\n$(LauncherRequiresAdmin)" \
			"$(LauncherAdminError)$\r$\n$(LauncherNotAdminLimitedFunctionality)"
	${EndSwitch}
FunctionEnd
!macro RunAsAdmin
	Push 7zFM.exe
	Call Find::Process
	IntCmp $_LOGICLIB_TEMP 1 0 +5
	Push ${APPNAME}.exe
	Call Find::Process
	IntCmp $_LOGICLIB_TEMP 1 0 +2
	StrCpy $SecondaryLaunch true
	${ConfigReads} `${CONFIG}` ShellExtension= $0
	StrCmpS $0 true +3
	StrCmpS $0 auto 0 +8
	StrCmpS $Admin true 0 +7
	StrCmpS $Bit 64 0 +5
	StrCmpS $App ${APP} 0 +4
	StrCmpS $SecondaryLaunch true +4
	MessageBox MB_ICONINFORMATION|MB_TOPMOST \ 
	`Shell Extension is incompatible with x86 Compatibility Mode.`
	Goto +2
	Call Elevate
!macroend
!define MsgBox "!insertmacro _MsgBox"
!macro _MsgBox
	StrCpy $MissingFileOrPath `Windows XP or newer`
	MessageBox MB_ICONSTOP|MB_TOPMOST `$(LauncherFileNotFound)`
	Call Unload
	Quit
!macroend
!macro OS
	${If} ${IsNT}
		${IfNot} ${AtLeastWinXP}
			${MsgBox}
		${EndIf}
	${Else}
		${MsgBox}
	${EndIf}
!macroend
Function PAL:LanguageLCID
	IfFileExists `${REG}` 0 +3
	ReadINIStr $0 `${REG}` `${LANG}` `"${KEY}"`
	Goto +2
	ReadINIStr $0 `${DEFREG}` `${LANG}` `"${KEY}"`
	${GetLCID} $0 $0
	${SetEnvironmentVariable} PAL:LanguageLCID $0
FunctionEnd
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
!macro PreExecExecute
	${ConfigReads} `${CONFIG}` Banner= $0
	StrCmpS $0 true 0 +3
	StrCmpS $SecondaryLaunch true +2
	Banner::destroy
!macroend
!macro Init
	${ConfigReads} `${CONFIG}` Banner= $0
	StrCmpS $0 true 0 +6
	Banner::show ""
	Banner::getWindow
	Pop $0
	GetDlgItem $0 $0 1030
	SendMessage $0 ${WM_SETTEXT} 0 "STR:$(i)"
	${Init::File} settings ${APP}.reg
!macroend
${SegmentPrePrimary}
	${File::BackupLocal} `${SND}`
	ReadEnvStr $1 PAL:LastDrive
	StrCpy $0 $EXEDIR 2
	${If} $0 != $1
		${Registry::StrToHexW} `$0\` $0
		${Registry::StrToHexW} `$1\` $1
		StrCpy $0 $0 2
		StrCpy $1 $1 2
		${ReplaceInFileU16CS} `${REG}` `$1,00,3a` `$0,00,3a`
	${EndIf}
	CreateShortCut `${SND}` `${EXE}` "" `${EXE}` 0
!macroend
${SegmentPostPrimary}
	${File::RestoreLocal} `${SND}`
!macroend
!macro PreDLL
	StrCmpS $RunAsAdmin force 0 +13
	ClearErrors
	ReadRegStr $0 HKLM `${CLSID}` ""
	IfErrors +10
	StrCpy $1 $0 1
	StrCmp $1 `"` 0 +2
	StrCpy $0 $0 "" 1
	StrCpy $1 $0 "" -1
	StrCmp $1 `"` 0 +2
	StrCpy $0 $0 -1
	${WriteRuntimeData} ${PAL} DLL `$0`
	UnRegDLL `$0`
!macroend
!macro PrePrimaryDLL
	StrCmpS $RunAsAdmin force 0 +10
	RegDLL `${DLL}`
	WriteRegStr HKLM `${CLSID}` "" `${DLL}`
	WriteRegStr HKLM `${CLSID}` ThreadingModel Apartment
	WriteRegStr HKLM `${KEY1}` "" `${VAL1}`
	WriteRegStr HKLM `${DIR1}` "" ${GUID}
	WriteRegStr HKLM `${DIR2}` "" ${GUID}
	WriteRegStr HKLM `${DRV}` "" ${GUID}
	WriteRegStr HKLM `${FLD}` "" ${GUID}
	WriteRegStr HKLM `${SHLX}` "" ${GUID}
!macroend
!macro PostPrimaryDLL
	StrCmpS $RunAsAdmin force 0 +2
	UnRegDLL `${DLL}`
!macroend
!macro UnloadDLL
	StrCmpS $RunAsAdmin force 0 +8
	ClearErrors
	${ReadRuntimeData} $0 ${PAL} DLL
	IfErrors +2
	RegDLL `$0`
!macroend
${SegmentUnload}
	${If} $RunAsAdmin == force
		${ConfigReads} `${CONFIG}` USBDevice= $0
		${If} $0 == true
			${If} ${FileLocked} `${DLL}`
				${Close} `${CABW}` ""
			${EndIf}
		${EndIf}
	${EndIf}
!macroend
!macro PreReg
	StrCpy $0 1
	${Do}
		ClearErrors
		${ReadLauncherConfig} $1 Associations $0
		${IfThen} ${Errors} ${|} ${ExitDo} ${|}
		${GetIconIndex} $1 $2
		${If} $2 != error
			StrCpy $3 1
			${ReadRuntimeData} $4 Associations $3
			StrCmp $4 "" +3
			IntOp $3 $3 + 1
			Goto -6
			${WriteRuntimeData} Associations $3 $1
			${Registry::BackupKey} `${CLS}\.$1` $2
			${Registry::BackupKey} `${CLS}\${APP}.$1` $2
			${Registry::BackupKey} `${EXT}\.$1` $2
			${Registry::BackupKey} `${EXTS}\.$1` $2
		${EndIf}
		IntOp $0 $0 + 1
	${Loop}
!macroend
!macro UnPreRegWrite
	StrCpy $0 1
	${Do}
		ClearErrors
		${ReadRuntimeData} $1 Associations $0
		${IfThen} ${Errors} ${|} ${ExitDo} ${|}
		${GetIconIndex} $1 $2
		WriteRegStr HKCU `${CL}\.$1` "" ${APP}.$1
		WriteRegStr HKCU `${D}` "" `"${ICO}",$2`
		WriteRegStr HKCU `${O}` "" `${ARC}`
		WriteRegStr HKCU `${O}` Icon `${EXE}`
		WriteRegStr HKCU `${C}` "" `"${EXE}" "%1"`
		IntOp $0 $0 + 1
	${Loop}
!macroend
!macro PostReg
	StrCpy $0 1
	${Do}
		ClearErrors
		${ReadRuntimeData} $1 Associations $0
		${IfThen} ${Errors} ${|} ${ExitDo} ${|}
		${Registry::RestoreBackupKey} `${CLS}\.$1` $2
		${Registry::RestoreBackupKey} `${CLS}\${APP}.$1` $2
		${Registry::RestoreBackupKey} `${EXT}\.$1` $2
		${Registry::RestoreBackupKey} `${EXTS}\.$1` $2
		${Registry::DeleteKeyEmpty} `${EXTS}` $2
		IntOp $0 $0 + 1
	${Loop}
!macroend