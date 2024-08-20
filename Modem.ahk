#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
#Persistent


;                         {[
;;           ELEVATE TO ADMIN UAC PROMPT BELOW
; If the script is not elevated, relaunch as administrator and kill current instance:
 
full_command_line := DllCall("GetCommandLine", "str")
 
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
;
;                          ]}

DetectHiddenText, On
DetectHiddenWindows, On


GLOBAL ConfigFileTitle := "modemConfig.cfg" ;; remove the X on the end!
GLOBAL config_path := A_ScriptDir . "\" . ConfigFileTitle
; config_path := A_MyDocuments . "\" . FolderTitleRoot . "\" . ConfigFileTitle
; create_config_path := A_MyDocuments . "\" . FolderTitleRoot
; create_modules_path := A_MyDocuments . "\" . FolderTitleRoot . "\modules"
; create_bnetOverseer_path := A_MyDocuments . "\" . FolderTitleRoot . "\modules\BNET Overseer"

; GLOBAL HeartbeatHotspotON := "start_hotspot_on_verify.ps1"

; GLOBAL AppTitleRoot := "HotSpots 2024"
IniRead, aAppTitleRoot, %config_path%, ENGINE, AppTitleRoot, 1
GLOBAL AppTitleRoot := aAppTitleRoot


GLOBAL AutoConnectOnTitle := "[" . AppTitleRoot . "]: Auto-Connect Status" 
GLOBAL AutoConnectOnMsg := "Auto-Connect Toggled On" 
GLOBAL AutoConnectOffTitle := "[" . AppTitleRoot . "]: Auto-Connect Status" 
GLOBAL AutoConnectOffMsg := "Auto-Connect Toggled Off" 


GLOBAL DbgTitle0x01 := "[" . AppTitleRoot . "]: DebugMsg Lvl--01" 
GLOBAL DbgTitle0x02 := "[" . AppTitleRoot . "]: DebugMsg Lvl--02" 
GLOBAL DbgTitle0x03 := "[" . AppTitleRoot . "]: DebugMsg Lvl--03" 
GLOBAL DbgTitle0x04 := "[" . AppTitleRoot . "]: DebugMsg Lvl--04" 

GLOBAL DbgMsgboxOption := "4096"  ;;; This is now unused because the options var for MsgBox commands is literal and doesn't accept string inputs
;; This is the default MsgBox modal settings used for all messageboxes
GLOBAL DbgGlobalTimeout := "23"
;; Global timeout in number of seconds for debugger messages

GLOBAL DownloadInternetTestFile := "DownloadTest.test"
;; This is the name of the test file we will try to download during the AutoConnect sequence used to determine if internet is connected or not, it will be auto-deleted during the DeleteDownloadTest label timer.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TOGGLE FLAG STRINGS
;;
;; These are usually one-time-use strings that are used to determine if labels or functions have run before or not, and change execution logic depending
;;
GLOBAL ReRunThreadsAutoexecFlag := "1"
GLOBAL ReRunStringsAutoexecFlag := "1"

GLOBAL ThreadToggle := "0" ;; This is used in the toggle threads tray menu button
GLOBAL AutoConnectToggle := "0"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; TRAY MENU STRUCT
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, SettingsBTN  ; Creates a new menu item.
Menu, Tray, Add, Open Container, OpenDirectoryRootBTN  ; Creates a new menu item.
; Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, Direct QuickHotspot, RunQHSThreadCall   ; Creates a new menu item.
; Menu, Tray, Add, Query PDAnet Uptime, pdaUptime_CallModuleBTN   ; Creates a new menu item.
; Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, StopWatch, OpenStopWatch  ;
; Menu, Tray, Add, Countdown Timer, OpenCountdownTimer  ;
; Menu, Tray, Add, Run Battle.net Overseer, OpenBNETHandler  ;
Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, Halt Root Threads, clampRootThreadCalls   ; Creates a new menu item.
Menu, Tray, Add, Stop Auto-HotSpot, clampHotSpotSThreadCall   ; Creates a new menu item.
Menu, Tray, Add, Start Auto-HotSpot, reRunHotSpotSThreadCall   ; Creates a new menu item.
Menu, Tray, Add, Toggle Auto-Connect, ToggleAutoConnect   ; Creates a new menu item.
Menu, Tray, Add, Toggle All Threads, ToggleAllThreads   ; Creates a new menu item.
; Menu, Tray, Add, Stop Auto-Server, clampServerThreadCalls   ; Creates a new menu item.
; Menu, Tray, Add, Start Auto-Server, reRunServerThreadCalls   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Refresh Routines, reRunThreads   ; Creates a new menu item.
Menu, Tray, Add, Refresh String Table, RefreshGlobalStrControl   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Reboot Engine, ReloadBTN   ; Creates a new menu item.
Menu, Tray, Add, Exit, ExitBTN   ; Creates a new menu item.


Menu, Tray, Tip, %AppTitleRoot%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




IniRead, MainHotspotSwitch, %config_path%, SWITCHES, AutoHotspot, 1
GLOBAL HotspotSwitch := MainHotspotSwitch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, SimplifiedAutoConnectSwitch, %config_path%, SWITCHES, SimpleAutoConnect, 0
GLOBAL SimpleAutoConnect := SimplifiedAutoConnectSwitch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, MainDoubleCleanupSwitch, %config_path%, SWITCHES, DoubleCleanupPass, 1
GLOBAL DoubleCleanupSwitch := MainDoubleCleanupSwitch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, DismissPDAMessages, %config_path%, PDANET, DismissPdaMessages, 1
GLOBAL DismissMessages := DismissPDAMessages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, HotspotVel, %config_path%, CONFIG, HotspotExecSpeed, 25000
GLOBAL HotspotExecuteSpeed := HotspotVel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, HotspotCleanupVel, %config_path%, CONFIG, HotspotCleanupSpeed, 31000
GLOBAL HotspotCleanupSpeed := HotspotCleanupVel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoDHCP, %config_path%, SWITCHES, HotspotAdapterSetAutoDHCP, 1
GLOBAL AutoDHCP := aAutoDHCP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAdapterDHCPbat, %config_path%, CONFIG, HotspotAdapterDHCPbat, set-DHCP.bat
GLOBAL AdapterDHCPbat := aAdapterDHCPbat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aDismissMessageSpeed, %config_path%, PDANET, DismissMessageSpeed, 600000 ;; 600000 MS = 10 minutes
GLOBAL DismissMessageSpeed := aDismissMessageSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoConnect, %config_path%, SWITCHES, AutoConnect, 1
GLOBAL AutoConnect := aAutoConnect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoConnectSpeed, %config_path%, CONFIG, AutoConnectSpeed, 14000
GLOBAL AutoConnectSpeed := aAutoConnectSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aDeleteDownloadTestSpeed, %config_path%, CONFIG, AutoConnectDeleteTestSpeed, 3500
GLOBAL DeleteDownloadTestSpeed := aDeleteDownloadTestSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aSimpAutoConnectSpeed, %config_path%, CONFIG, SimpleAutoConnectSpeed, 15000
GLOBAL SimpAutoConnectSpeed := aSimpAutoConnectSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aPDAdirectory, %config_path%, PDANET, Container, C:\Program Files (x86)\PdaNet for Android
GLOBAL PDAdirectory := aPDAdirectory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aPDAExecutable, %config_path%, PDANET, Executable, PdaNetPC.exe
GLOBAL PDAExecutable := aPDAExecutable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; RUN THREADS MAIN (ALSO CALLED BY REFRESH BUTTON IN TRAY + READ DURING AUTOEXEC)
RunThreads:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 01
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(ReRunThreadsAutoexecFlag="1")
    {
    If(DevDebuggerLevel="1")
        {
        MsgBox, 4096, %DbgTitle0x01%, RunThreads label executed during autoexec call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
        }
    }
    Else
    {
    If(DevDebuggerLevel="1")
        {
        MsgBox, 4096, %DbgTitle0x01%, RunThreads label executed during TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
        }
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
If(HotspotSwitch="1")
{
SetTimer, HotSpotThread, %HotspotExecuteSpeed%
SetTimer, HotSpotCleanupThread, %HotspotCleanupSpeed%
}



If(AutoConnect="1")
{
    IniWrite, 0, %config_path%, SWITCHES, SimpleAutoConnect
    IniRead, SimplifiedAutoConnectSwitch, %config_path%, SWITCHES, SimpleAutoConnect, 0
    GLOBAL SimpleAutoConnect := SimplifiedAutoConnectSwitch
    SetTimer, UnintelligentAutoConnect, Off

    SetTimer, DetermineInternetConnectivity, %AutoConnectSpeed%
    SetTimer, DeleteDownloadTest, %DeleteDownloadTestSpeed%
}
If(SimpleAutoConnect="1")
{
IniRead, aSimpAutoConnectSpeed, %config_path%, CONFIG, SimpleAutoConnectSpeed, 15000
GLOBAL SimpAutoConnectSpeed := aSimpAutoConnectSpeed
    IniWrite, 0, %config_path%, SWITCHES, AutoConnect
    IniRead, aAutoConnect, %config_path%, SWITCHES, AutoConnect, 1
    GLOBAL AutoConnect := aAutoConnect
    SetTimer, DetermineInternetConnectivity, Off
    SetTimer, DeleteDownloadTest, Off

    SetTimer, UnintelligentAutoConnect, %SimpAutoConnectSpeed%
}



If(DismissMessages="1")
{
    SetTimer, DismissPDAerrors, %DismissMessageSpeed%
    ;; DEFAULT 600000 MS = 10 minutes
}


IniRead, aLaunchRazerCortex, %config_path%, CORTEX, LaunchRazerCortex, 1
IniRead, aLaunchRazerCortexDelay, %config_path%, CORTEX, LaunchDelay, 1
IniRead, aCortexWindowDelay, %config_path%, CORTEX, WindowCloseDelay, -7000
IniRead, aCortexWinWaitDelay, %config_path%, CORTEX, WindowWaitDelay, 12
If(aLaunchRazerCortex="1")
{
SetTimer, LaunchRazerCortexLabel, %aLaunchRazerCortexDelay%
}
If(aLaunchRazerCortex="1")
{
WinWait, Razer Cortex,, %aCortexWinWaitDelay%
SetTimer, CloseCortexWindow, %aCortexWindowDelay%
}


IniRead, aLaunchPDANet, %config_path%, PDANET, LaunchPDAnet, 1
IniRead, aLaunchPDANetDelay, %config_path%, PDANET, LaunchDelay, 1
If(aLaunchPDANet="1")
{
SetTimer, LaunchPDANetLabel, %aLaunchPDANetDelay%
}



GLOBAL ReRunThreadsAutoexecFlag := "0"  ;; Set the toggle flag for autoexec exection of RunThreads to off, so we know any subsequent executions of RunThreads is via the TrayMenu call and not autoexec.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; RERUN STRINGS BUTTON ACTION
ReRunStrings:
IniRead, aPDAExecutable, %config_path%, PDANET, Executable, PdaNetPC.exe
GLOBAL PDAExecutable := aPDAExecutable
GLOBAL PDATarget := PDAdirectory . "\" . PDAExecutable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, MainHotspotSwitch, %config_path%, SWITCHES, AutoHotspot, 1
GLOBAL HotspotSwitch := MainHotspotSwitch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, MainDoubleCleanupSwitch, %config_path%, SWITCHES, DoubleCleanupPass, 1
GLOBAL DoubleCleanupSwitch := MainDoubleCleanupSwitch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, HotspotVel, %config_path%, CONFIG, HotspotExecSpeed, 25000
GLOBAL HotspotExecuteSpeed := HotspotVel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, HotspotCleanupVel, %config_path%, CONFIG, HotspotCleanupSpeed, 31000
GLOBAL HotspotCleanupSpeed := HotspotCleanupVel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoDHCP, %config_path%, SWITCHES, HotspotAdapterSetAutoDHCP, 1
GLOBAL AutoDHCP := aAutoDHCP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAdapterDHCPbat, %config_path%, CONFIG, HotspotAdapterDHCPbat, set-DHCP.bat
GLOBAL AdapterDHCPbat := aAdapterDHCPbat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoConnect, %config_path%, SWITCHES, AutoConnect, 1
GLOBAL AutoConnect := aAutoConnect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoConnectSpeed, %config_path%, CONFIG, AutoConnectSpeed, 23000
GLOBAL AutoConnectSpeed := aAutoConnectSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aSimpAutoConnectSpeed, %config_path%, CONFIG, SimpleAutoConnectSpeed, 15000
GLOBAL SimpAutoConnectSpeed := aSimpAutoConnectSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aPDAdirectory, %config_path%, PDANET, Container, C:\Program Files (x86)\PdaNet for Android
GLOBAL PDAdirectory := aPDAdirectory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aDeleteDownloadTestSpeed, %config_path%, CONFIG, AutoConnectDeleteTestSpeed, 3500
GLOBAL DeleteDownloadTestSpeed := aDeleteDownloadTestSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;
;;;;;;; DEBUGGER LEVEL 01
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(ReRunStringsAutoexecFlag="1")
    {
    If(DevDebuggerLevel="1")
        {
        MsgBox, 4096, %DbgTitle0x01%, ReRunThreads label executed during autoexec call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
        }
    }
    Else
    {
    If(DevDebuggerLevel="1")
        {
        MsgBox, 4096, %DbgTitle0x01%, ReRunThreads label executed during TrayMenu call`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
        }
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
; ;;;;;;;
; ;;;;;;; DEBUGGER LEVEL 01
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="1")
;     {
;      MsgBox, 4096, %DbgTitle0x01%, ReRunThreads label executed during autoexec or TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
;     }
; }
; ;;;;;;;
; ;;;;;;;
; ;;;;;;;
GLOBAL ReRunStringsAutoexecFlag := "0"  ;; Set the toggle flag for autoexec exection of reRunStrings to off, so we know any subsequent executions of ReRunStrings is via the TrayMenu call and not autoexec.
Return








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MAIN TIMER LABELS / ROUTINES
;;;;
;;;;
;;;; HOTSPOT TIMER THREAD
HotSpotThread:
; Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File %HeartbeatHotspotON%,,Hide
Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File C:\start_hotspot_on_verify.ps1,,Hide
;;;;;;;
;;;;;;; DEBUGGER LEVEL 03
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="3")
    {
     MsgBox, 4096, %DbgTitle0x03%, {HotSpotThread} Main label executed during SetTimer call., 10
    }
}
;;;;;;;  Debugger ignores global timeout option here and uses 10 seconds instead
;;;;;;;
;;;;;;;
Return
;;;;
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;
;;;; HOTSPOT CLEANUP TIMER THREAD
HotSpotCleanupThread:
Process, Close, Powershell.exe
Process, Close, Powershell.exe
Process, Close, Powershell.exe

If(DoubleCleanupSwitch="1")
{
Process, Close, Powershell.exe
Process, Close, Powershell.exe
Process, Close, Powershell.exe
;;;;;;;
;;;;;;; DEBUGGER LEVEL 03
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
If(DevDebugger="1")
{
    IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
    GLOBAL DevDebuggerLevel := aDevDebuggerLevel
    If(DevDebuggerLevel="3")
    {
     MsgBox, 4096, %DbgTitle0x03%, {DoubleCleanupSwitch} Main Sub-config setting equals 1 so it was executed during SetTimer call., 10
    }
}
;;;;;;;  Debugger ignores global timeout option here and uses 10 seconds instead
;;;;;;;
;;;;;;;
}
;;;;;;;
;;;;;;; DEBUGGER LEVEL 03
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
If(DevDebugger="1")
{
    IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
    GLOBAL DevDebuggerLevel := aDevDebuggerLevel
    If(DevDebuggerLevel="3")
    {
     MsgBox, 4096, %DbgTitle0x03%, {HotSpotCleanupThread} Main Sub-label executed during SetTimer call., 10
    }
}
;;;;;;;  Debugger ignores global timeout option here and uses 10 seconds instead
;;;;;;;
;;;;;;;
Return
;;;;
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;
;;;; AUTOCONNECT TIMER THREAD
DetermineInternetConnectivity:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 03
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="4")
    {
     MsgBox, 4096, %DbgTitle0x03%, {DetermineInternetConnectivity} label executed during SetTimer call.`n`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
GLOBAL ConfigFileTitle := "modemConfig.cfg" ;; remove the X on the end!
GLOBAL config_path := A_ScriptDir . "\" . ConfigFileTitle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoConnect, %config_path%, SWITCHES, AutoConnect, 1
GLOBAL AutoConnect := aAutoConnect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aAutoConnectSpeed, %config_path%, CONFIG, AutoConnectSpeed, 23000
GLOBAL AutoConnectSpeed := aAutoConnectSpeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aPDAdirectory, %config_path%, PDANET, Container, C:\Program Files (x86)\PdaNet for Android
GLOBAL PDAdirectory := aPDAdirectory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, aPDAExecutable, %config_path%, PDANET, Executable, PdaNetPC.exe
GLOBAL PDAExecutable := aPDAExecutable
GLOBAL PDATarget := PDAdirectory . "\" . PDAExecutable
If(AutoConnect="1")
{
    If IsInternetConnected()
    {
    ;;;;;;;
    ;;;;;;; DEBUGGER LEVEL 03
    If(DevDebugger="1")
    {
    If(DevDebuggerLevel="4.1")
        {
        MsgBox, 4096, %DbgTitle0x04%, If {IsInternetConnected} AutoConnect SetTimer Func call determined: `n`n Internet connected!, %DbgGlobalTimeout%
        }
    }
    ;;;;;;;
    ;;;;;;;
    ;;;;;;;
    }
    Else
    {
    ;;;;;;;
    ;;;;;;; DEBUGGER LEVEL 03
    If(DevDebugger="1")
    {
    If(DevDebuggerLevel="4.1")
        {
        MsgBox, 4096, %DbgTitle0x04%, If {IsInternetConnected} AutoConnect SetTimer Func call determined: `n`n Internet is not connected!, %DbgGlobalTimeout%
        }
    }
    ;;;;;;;
    ;;;;;;;
    ;;;;;;;
    Run, %PDATarget%
    }
}
Return
; DetermineInternetConnectivity:
; If IsInternetConnected()
; {
;     ; MsgBox Connected!

; }
; Else
; {
;     ; MsgBox Not Connected!
;     Run, %PDATarget%
; }


DeleteDownloadTest:
FileDelete, %A_ScriptDir%\%DownloadInternetTestFile%
;;;;;;;
;;;;;;; DEBUGGER LEVEL 03
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="4.2")
    {
     MsgBox, 4096, %DbgTitle0x04%, {DeleteDownloadTest} label executed during SetTimer call., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
Return



UnintelligentAutoConnect:
    If(DevDebugger="1")
    {
    If(DevDebuggerLevel="4.1")
        {
        MsgBox, 4096, %DbgTitle0x04%, Simplified Unintelligent Auto-Connect Routine executed. `n`n PDANet Executable Called without Internet check calls!, %DbgGlobalTimeout%
        }
    }
    ;;;;;;;
    ;;;;;;;
    ;;;;;;;
    Run, %PDATarget%
Return








DismissPDAerrors:
IniRead, DismissPDAMessages, %config_path%, PDANET, DismissPdaMessages, 1
GLOBAL DismissMessages := DismissPDAMessages
IniRead, aDismissMessageSpeed, %config_path%, PDANET, DismissMessageSpeed, 600000 ;; 600000 MS = 10 minutes
GLOBAL DismissMessageSpeed := aDismissMessageSpeed
If(DismissMessages="1")
{
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
    WinClose, %PDANETerror%
}
Else
{
        SetTimer, DismissPDAerrors, Off
        ;; DEFAULT 600000 MS = 10 minutes
}
Return



LaunchRazerCortexLabel:
IniRead, aCortexContainer, %config_path%, CORTEX, CortexContainer, 1

Run, %aCortexContainer%

Return

CloseCortexWindow:
PostMessage, 0x0112, 0xF060,,, Razer Cortex, ; 0x0112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
Return




LaunchPDANetLabel:
Run, %PDATarget%
Return


; Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAY BUTTON LABELS
clampHotSpotSThreadCall:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {clampRunHotSpotsThread} label executed during TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
SetTimer, HotSpotThread, Off
SetTimer, HotSpotCleanupThread, Off
Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File C:\start_hotspot_off_verify.ps1,,Hide
return



reRunHotSpotSThreadCall:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {reRunHotSpotsThread} label executed during TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File C:\start_hotspot_on_verify.ps1,,Hide
SetTimer, HotSpotThread, %HotspotExecuteSpeed%
SetTimer, HotSpotCleanupThread, %HotspotCleanupSpeed%
return


reRunThreads:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {reRunThreads} label executed during TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
SetTimer, RunThreads, -550
return




ToggleAutoConnect:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {ToggleAutoConnect} label executed during TrayMenu call., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
If(AutoConnectToggle="0")
{
    GLOBAL AutoConnectToggle := "1"
    SetTimer, DeleteDownloadTest, Off
    SetTimer, DetermineInternetConnectivity, Off
    MsgBox, 4096, %AutoConnectOffTitle%, %AutoConnectOffMsg%, %DbgGlobalTimeout%
    Return
}
If(AutoConnectToggle="1")
{
    GLOBAL AutoConnectToggle := "0"
    ; MsgBox,,, Toggle State B
    IniRead, aDeleteDownloadTestSpeed, %config_path%, CONFIG, AutoConnectDeleteTestSpeed, 3500
    GLOBAL DeleteDownloadTestSpeed := aDeleteDownloadTestSpeed
    IniRead, aAutoConnect, %config_path%, SWITCHES, AutoConnect, 1
    GLOBAL AutoConnect := aAutoConnect
    IniRead, aAutoConnectSpeed, %config_path%, CONFIG, AutoConnectSpeed, 23000
    GLOBAL AutoConnectSpeed := aAutoConnectSpeed
        ; If(AutoConnect="1")
        ; {
        SetTimer, DetermineInternetConnectivity, %AutoConnectSpeed%
        SetTimer, DeleteDownloadTest, %DeleteDownloadTestSpeed%
        ; }
    MsgBox, 4096, %AutoConnectOnTitle%, %AutoConnectOnMsg%, %DbgGlobalTimeout%
    Return
}
Return







ToggleAllThreads:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {ToggleAllThreads} label executed during TrayMenu call., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
If(ThreadToggle="0")
{
    GLOBAL ThreadToggle := "1"
    ; MsgBox,,, Toggle State A
    SetTimer, HotSpotThread, Off
    SetTimer, HotSpotCleanupThread, Off
    SetTimer, ReRunStrings, Off
    SetTimer, RunThreads, Off
    SetTimer, DeleteDownloadTest, Off
    SetTimer, DetermineInternetConnectivity, Off
    Return
}
If(ThreadToggle="1")
{
    GLOBAL ThreadToggle := "0"
    ; MsgBox,,, Toggle State B
    SetTimer, RunThreads, -550
    Return
}
Return



SettingsBTN:
; Run, "notepad.exe" %A_MyDocuments%\HotSpots\autohotspot_handler.cfg
; Run, "notepad.exe" %A_MyDocuments%\HotSpots\%ConfigFileTitle%
Run, "notepad.exe" %config_path%
    ; If(ShowDebugMessages="4")
    ; {
    ;     MsgBox,, [ChainOverflow]: Settings Control Event, Executing partially hard-coded directory,
    ; }
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {SettingsBTN} label executed during TrayMenu call., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
return



ReloadBTN:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {ReloadBTN} label executed during TrayMenu call.--Preparing to re-execute the engine subsystem..., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
Reload
Return



OpenDirectoryRootBTN:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {OpenDirectoryRootBTN} label executed during TrayMenu call., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
Run, explorer.exe ""%A_ScriptDir%""
Return



RefreshGlobalStrControl:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
GLOBAL DevDebugger := aDevDebugger
IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
GLOBAL DevDebuggerLevel := aDevDebuggerLevel
If(DevDebugger="1")
{
    If(DevDebuggerLevel="2")
    {
     MsgBox, 4096, %DbgTitle0x02%, {RefreshGlobalStrControl} label executed during TrayMenu call., %DbgGlobalTimeout%
    }
}
;;;;;;;
;;;;;;;
;;;;;;;
SetTimer, ReRunStrings, -550
Return



Return
ExitBTN:
ExitApp
Return





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FUNCTIONS


Return
ProcessExist(PIDorName:="")
{
    Process Exist, %PIDorName%
    return ErrorLevel
}
Return




Return
IsInternetConnected()
{
    UrlDownloadToFile, https://github.com/A-gent/-fLoat-/raw/developmentonly/engineMain.cpp, %DownloadInternetTestFile%
    Return !ErrorLevel
    ; SetTimer, DeleteDownloadTest, -1500
}
Return
; {
;   static sz := A_IsUnicode ? 408 : 204, addrToStr := "Ws2_32\WSAAddressToString" (A_IsUnicode ? "W" : "A")
;   VarSetCapacity(wsaData, 408)
;   if DllCall("Ws2_32\WSAStartup", "UShort", 0x0202, "Ptr", &wsaData)
;     return false
;   if DllCall("Ws2_32\GetAddrInfoW", "wstr", "dns.msftncsi.com", "wstr", "http", "ptr", 0, "ptr*", results)
;   {
;     DllCall("Ws2_32\WSACleanup")
;     return false
;   }
;   ai_family := NumGet(results+4, 0, "int")    ;address family (ipv4 or ipv6)
;   ai_addr := Numget(results+16, 2*A_PtrSize, "ptr")   ;binary ip address
;   ai_addrlen := Numget(results+16, 0, "ptr")   ;length of ip
;   DllCall(addrToStr, "ptr", ai_addr, "uint", ai_addrlen, "ptr", 0, "str", wsaData, "uint*", 204)
;   DllCall("Ws2_32\FreeAddrInfoW", "ptr", results)
;   DllCall("Ws2_32\WSACleanup")
;   http := ComObjCreate("WinHttp.WinHttpRequest.5.1")

;   if (ai_family = 2 && wsaData = "131.107.255.255:80")
;   {
;     http.Open("GET", "http://www.msftncsi.com/ncsi.txt")
;   }
;   else if (ai_family = 23 && wsaData = "[fd3e:4f5a:5b81::1]:80")
;   {
;     http.Open("GET", "http://ipv6.msftncsi.com/ncsi.txt")
;   }
;   else
;   {
;     return false
;   }
;   http.Send()
;   return (http.ResponseText = "Microsoft NCSI") ;ncsi.txt will contain exactly this text
; }
; Return