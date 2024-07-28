# DESCRIPTION

<p align="left">
This program offers a few functionalities to pair with a PdaNet setup.
If can silently force the computer to host and upkeep a Windows Hotspot for using a computer as an access point for your PdaNet connection. This can be a weaker option for people with weaker WiFi cards though, because the quality of your WiFi card on your PdaNet-connected Windows PC will bottleneck the stability and speed of your WiFi network's connection. If said PC has a very good dedicated (or even onboard) WiFi card/chip, then this can be a decent choice. But the more clients / devices you have connected to your Windows Hotspot, the more the quality will degrade even if you have a very good WiFi card/chip.
</p>
<br>
  
<p align="center">
I prefer to use a laptop with a Type-C port and an ethernet port as a "Modem" PC, connecting it to PdaNet via a Type-C-to-Type-C cable, connecting the laptop via ethernet to the WAN port of a router (the modem port), and then configuring windows connection sharing of the PdaNet Broadband adapter to share its internet connection to the ethernet port, then connecting PCs directly to the router via ethernet to its LAN ports for a much more stable and fast dedicated connection. But this also serves up a much more stable and fast WiFi connection as well because you can use a router to host the network. I am using an ASUS router (RT-AC56R) to do this, and I use this modem software to autonomously upkeep 95% of issues that can occur with PdaNet in the background. The only intervention this method requires is an occasional manual reboot of the phone every 5-7 days whenever the speeds get a bit slower (but that's much better than the daily reboot needed with the Windows Hotspot method!). When I do this reboot, I ensure to wipe the phone's cache and perform a repair apps routine in the Boot Recovery Menu of the Android phone, and this system works beautifully. Its the exact same as having a cable internet connection, as I have 5G speeds and unlimited data.
</p>
<br>
<br>

This program can also poll for internet access and if it detects its not connected, it can attempt to force PdaNet to reconnect to your phone (very useful for the micro drops that sometimes occur with PdaNet).

The program also includes functionality to handle Razer Cortex, useful to pare back unneeded Windows features on a laptop "Modem" PC if you are going to run it that way.

<br>
<br>

## SETUP

<p align="left">

ON THE MODEM PC (OR THE PC YOU WANT TO USE WINDOWS HOTSPOT WITH PDANET):<br>

1.) Download and install [AutoHotkey version 1.1](https://autohotkey.com/download/ahk-install.exe).

2.) Download either the [latest release of this modem script](https://github.com/A-gent/PDAnet-Modem-PC-Handler/releases/download/v1.0.097/ModemHandler_v1.0.097.zip) OR [directly download the repo files](https://github.com/A-gent/PDAnet-Modem-PC-Handler/archive/refs/heads/main.zip) (if you download the repo files you will need to compile the modem.ahk file manually by right click and clicking compile script).

3.) Unzip the contents of this zip file to any location that you wish it to run from. (If you don't want to use the pre-compiled .exe file, compile the .ahk file manually by right clicking and clicking compile script)
  
4.) Move the 4 powershell script files:<br>"start_hotspot_off_verify.ps1", "start_hotspot_on_verify.ps1", "start_hotspot_verify.ps1", and "start_hotspot_verify_only.ps1"<br> to the root of your system drive ("C:" drive) OR add the folder you chose to be the Modem script's install location to your System Path under Windows environment variables.

5.) Hit windows key, type task scheduler, press enter when it appears in the list: <br> -On the left side, right click "Task Scheduler Library" and select Create Task. <br> -Give it a name, check "run with the highest priviledges", set "configure for" to Windows 10. <br> -Click triggers tab, click new, click the drop menu next to "Begin the task:", then select "at log-on", tick the "Specific user" bubble, press ok. <br> -Click the actions tab, click new, click browse and then navigate to the compiled .exe script application file wherever you unzipped the modem script to, press okay. <br> -Click conditions tab, uncheck "Start the task only if the computer is on AC power" (Unless you prefer it that way). <br> -Click settings tab, click the drop menu next to "Stop the task if it runs longer than:" and change it to 1 hour, click the drop menu that says "Do not start a new instance" and change it to "Stop the existing instance". <br> -Press ok. Now the modem script will launch itself every time you first log into your user account.

6.) Enable Powershell script execution: <br> -Hit windows key, type powershell.exe, right click and right as administrator. <br> -In the Powershell terminal run this command:  set-executionpolicy remotesigned <br> -When prompted if you are sure, just type A and hit enter to say "Yes To All". Then right click each of the files and check unblock and hit apply and ok for each file individually.

7.) Now configure your settings inside of the "modemConfig.cfg" file (with notepad), using the table below, then reboot your PC. The script will be running in your taskbar tray. If you right click it, there are controls to micro-manage the application directly from its Tray Menu if you wish to do so, but otherwise just let it autopilot.

8.) *OPTIONAL*: Add PdaNetPC.exe to your Razer Cortex as a game, and configure Razer Cortex's boosting settings and turn on auto-boost, so this way any time PdaNetPC.exe launches, it will automatically apply your boosts. Also optionally, use Razer Cortex to do the network tweaks, but be careful which services you disable in your Razer Cortex booster settings. If you don't want to deal with this, just skip the Cortex and change "LaunchRazerCortex=1" to "LaunchRazerCortex=0" under the "CORTEX" section of the confile file to disable Cortex module.
<br>

</p>
<br><br>

## "modemConfig.cfg" SETTINGS FILE TABLE
<p align="center">
Below is a table of contents with the names of each configurable setting, its corresponding default value, acceptable value ranges, and description explaining its purpose and use.
</p>

| CONFIG FILE COMMAND   |      SECTION      |  VALUE RANGE | DEFAULT VALUE | DESCRIPTION |
|-----------------------|:-----------------:|-------------:|--------------:|------------:|
| AutoHotspot |                    SWITCHES       |   0-1 |           1    |   If equals 1, runs a timer thread that executes a powershell script to force a Windows Hotspot open, and periodically re-runs that script to keep it open.<br> The time inbetween executions is configurable below.<br><br> Automatically launches a secondary timer thread that closes powershell instances left open in the background. |
| AutoConnect |                    SWITCHES       |   0-1 |           1    |   If equals 1, runs a function to check if the computer is connected to the internet currently and if it is not,<br> it will attempt to force PdaNet to reconnect to the phone.<br> (Used to ensure that when PdaNet connection disconnects randomly, it will reconnect itself.)<br> The time inbetween executions is configurable below.<br><br> *NOTE*: Will not be able to force the phone to turn PdaNet USB tethering on, though, but thankfully that is a very rare thing to turn itself off. |
| DoubleCleanupPass |              SWITCHES       |   0-1 |           1    |   If equals 1, when the AutoHotspot cleanup timer thread runs this will force the powershell process killer to do a double pass (every time it executes) to close even more instances of powershell processes running the background.<br><br> *NOTE*: This setting pertains to the secondary timer that's launched by the AutoHotspot setting that closes background powershell processes to cleanup after the AutoHotspot thread after each execution. |
| HotspotAdapterSetAutoDHCP |      SWITCHES       |   0-1                   |   1   |  This sets DHCP on the the automatic Windows Hotspot created by the AutoHotspot thread.<br><br> The target name of the Hotspot adapter can be configured under the "HotspotAdapterName" setting below. The default setting is simply the one that I use on my own PC so if you wish to use this feature you need to configure the target first.<br><br> *NOTE*: This currently is a bugged feature, though, and should not be used as of right now until I patch it or you do it yourself. |
| AutoConnectSpeed |      CONFIG                  |   USER DEFINED          | 14000 |   This is the default amount of time in miliseconds that the AutoConnect timer thread executes at.<br><br> The default time is 14000 which is 14 seconds.<br><br> *NOTE*: This time must be LESS than "AutoConnectDeleteTestSpeed" no matter what you choose to set them both to. |
| AutoConnectDeleteTestSpeed |    CONFIG          |   USER DEFINED          | 16900 |   This is the default amount of time in miliseconds that the AutoConnect test file (used to check if you are currently connected to the internet) deletion thread executes at.<br><br> This thread downloads a dummy file to test for internet connectivity.<br><br> The default time is 16900 which is 16.9 seconds.<br><br> *NOTE*: This time must be GREATER than "AutoConnectSpeed" no matter what you choose to set them both to. |
| HotspotExecSpeed |      CONFIG                  |   USER DEFINED          | 15000 |   This is the default amount of time in miliseconds that the AutoHotspot timer thread executes at.<br><br> The default time is 15000 which is 15 seconds.<br><br> *NOTE*: This time must be LESS than "HotspotCleanupSpeed" no matter what you choose to set it to.   |
| HotspotCleanupSpeed |      CONFIG               |   USER DEFINED          | 21000 |   This is the default amount of time in miliseconds that the AutoHotspot powershell process killer thread (used to close excess instances of powershell scripts left open by the AutoHotspot thread) executes at.<br><br> This thread just kills any running powershell.exe processes.<br><br> The default time is 21000 which is 21 seconds.<br><br> *NOTE*: This time must be GREATER than "HotspotExecSpeed" no matter what you choose to set them both to. |
| HotspotAdapterName |      CONFIG                |   USER DEFINED          | Local Area Connection* 14 |   This is the name of the Windows Hotspot Adapter created in your network adapters page whenever the Windows Hotspot is currently turned on.<br><br> *NOTE*: This is used by the currently bugged "HotspotAdapterSetAutoDHCP" setting. |
| HotspotAdapterDHCPbat |      CONFIG             |       N/A               |  set-DHCP.bat |   This is the name of the DHCP execution script used to automatically experimentally set DHCP on the Windows Hotspot adapter.<br><br> *NOTE*: This is tied to the "HotspotAdapterSetAutoDHCP" setting above, and is currently a bugged feature so do not use this right now. |
| LaunchPDAnet |      PDANET                      |   0-1          | 1      |   If equals 1, launches PdaNet process on Modem script startup.  |
| LaunchDelay |      PDANET                       |   USER DEFINED          | -15500 |   The default amount of time in miliseconds that the "LaunchPDAnet" timer thread launches PdaNet process on Modem script startup.<br><br> The default time is "-15500" which is 15.5 seconds and the negative dash in front ensures this timer only runs once. <br><br> *NOTE*: This value should always be negative so that way it only runs once on startup. Putting a non-negative value here makes it constantly attempt to launch even after it already has!  |
| Container |      PDANET                         |   USER DEFINED          | C:\Program Files (x86)\PdaNet for Android |   This is the install location of your PdaNet install folder.<br><br> If you have it installed in a non-standard location, or have a different drive letter for your system drive other than "C:\", then configure this to your current PdaNet install location.<br><br> Otherwise, you can use the default value. |
| Executable |      PDANET                        |   USER DEFINED          |   PdaNetPC.exe   |   This is the name of your PdaNet executable file. |
| DismissPdaMessages |      PDANET                |        0-1              |       1       |   If equals 1, automatically runs a timer thread to close any existing PdaNet connection error message boxes. |
| DismissMessageSpeed |      PDANET               |   USER DEFINED          |     600000    |   This is the default amount of time in miliseconds that the "DismissPdaMessages" timer thread will execute at.<br><br> The default time is 600000 which is 10 minutes. |
| LaunchRazerCortex |      CORTEX                 |   0-1              |  1 |   If equals 1, launches Razer Cortex process on Modem script startup.  |
| LaunchDelay |      CORTEX                       |   USER DEFINED          |  -1500 |   The default amount of time in miliseconds that the "LaunchRazerCortex" timer thread launches Cortex process on Modem script startup.<br><br> The default time is "-1500" which is 1.5 seconds and the negative dash in front ensures this timer only runs once. <br><br> *NOTE*: This value should always be negative so that way it only runs once on startup. Putting a non-negative value here makes it constantly attempt to launch even after it already has!  |
| CortexContainer |      CORTEX                   |  USER DEFINED           |  C:\Program Files (x86)\Razer\Razer Cortex\RazerCortex.exe |   This is the directory / folder path to your Razer Cortex installation.  |
| WindowWaitDelay |      CORTEX                 |   USER DEFINED            |  15 |   The default amount of time in second that the "LaunchRazerCortex" thread timer waits for the existence of the Cortex window, in order to prepare to close it in the "WindowCloseDelay" setting below.<br><br> The default is "15" which is 15 seconds.  |
| WindowCloseDelay |      CORTEX                 |   USER DEFINED            |  15 |   The default amount of time in second that the "LaunchRazerCortex" thread timer closes the Cortex Window.<br><br> The default is "15" which is 15 seconds.  |
| AppTitleRoot |      ENGINE                      |   USER DEFINED          | Modem Handler |   This is simply the name that appears in the TrayTip message when you hover over the executable in the Windows Taskbar Tray |
| Debugger |      DEBUG                           |        0-1              |               |   This is used to debug the execution of routines within all threads and points of execution.<br> It will show messages for certain execution points / threads depending on the value of "DebuggerLevel" below.<br><br> Example: If "DebuggerLevel" = 3 then whenever the "DoubleCleanupPass" timer thread executes and clears a few If statements, then it will throw a MessageBox with information denoting that this has just occured.<br><br> If this setting equals 0, it will disable the debugger entirely and invalidate any values given under the "DebuggerLevel". |
| DebuggerLevel |      DEBUG                      |    1,<br> 2,<br> 3,<br> 4,<br> 4.1,<br> 4.2 |       1       |   If equals 1, Debugs All Main Execution Routines.<br><br> If equals 2, Debugs All Button Routines <br>(buttons found in the right click TrayMenu for the executable in the Taskbar Tray).<br><br> If equals 3, Debugs All Timer Routines.<br><br> If equals 4, Debugs The AutoConnect Timer Thread.<br><br> If equals 4.1, Debugs The AutoConnect IsInternetConnected() Function Timer Thread.<br><br> If equals 4.2, Debugs The AutoConnect DeleteDownloadTest Timer Thread.  |
