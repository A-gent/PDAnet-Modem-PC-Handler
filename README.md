# DESCRIPTION

This program offers a few functionalities to pair with a PdaNet setup.
If the "AutoHotspot" switch in the modemConfig.cfg file equals 1, it will Force the computer to silently 


| CONFIG FILE COMMAND   |      SECTION      |  VALUE RANGE | DEFAULT VALUE | DESCRIPTION |
|-----------------------|:-----------------:|-------------:|--------------:|------------:|
| AutoHotspot |                    SWITCHES       |   0-1 |           1    |   If equals 1, runs a timer thread that executes a powershell script to force a Windows Hotspot open, and periodically re-runs that script to keep it open. Automatically launches a secondary timer thread that closes powershell instances left open in the background. |
| AutoConnect |                    SWITCHES       |   0-1 |           1    |   If equals 1, runs a function to check if the computer is connected to the internet currently, and if it is not, it will attempt to force PdaNet to reconnect to the phone. (Used to ensure that when PdaNet connection disconnects randomly, it will reconnect itself. Will not be able to force the phone to turn PdaNet USB tethering on, though, but thankfully that is a very rare thing to turn itself off.) |
| DoubleCleanupPass |              SWITCHES       |   0-1 |           1    |   If equals 1, when the AutoHotspot cleanup timer thread runs (the timer that closes background powershell processes to cleanup after the AutoHotspot thread after each run) this will force the powershell process killer to do a double pass to close even more instances of powershell processes running the background. |
| HotspotAdapterSetAutoDHCP |      SWITCHES       |   0-1                   |   1   |  This sets DHCP on the the automatic Windows Hotspot created by the AutoHotspot thread. The target name of the Hotspot adapter can be configured under the "HotspotAdapterName" setting below. The default setting is simply the one that I use on my own PC so if you wish to use this feature you need to configure the target first. *NOTE*: This currently is a bugged feature, though, and should not be used as of right now. |
| AutoConnectSpeed |      CONFIG                  |   USER DEFINED          | 14000 |    |
| AutoConnectDeleteTestSpeed |    CONFIG          |   USER DEFINED          | 16900 |    |
| HotspotExecSpeed |      CONFIG                  |   USER DEFINED          | 15000 |    |
| HotspotCleanupSpeed |      CONFIG               |   USER DEFINED          | 21000 |    |
| HotspotAdapterName |      CONFIG                |   USER DEFINED          | Local Area Connection* 14 |    |
| HotspotAdapterDHCPbat |      CONFIG             |       N/A               |  set-DHCP.bat |    |
| Container |      PDANET                         |   USER DEFINED          | C:\Program Files (x86)\PdaNet for Android |    |
| Executable |      PDANET                        |   USER DEFINED          |   PdaNetPC.exe   |    |
| DismissPdaMessages |      PDANET                |        0-1              |   1  |    |
| DismissMessageSpeed |      PDANET               |   USER DEFINED          |      |    |
| AppTitleRoot |      ENGINE                      |   USER DEFINED          |      |    |
| Debugger |      DEBUG                           |        0-1              |      |    |
| DebuggerLevel |      DEBUG                      |    1, 2, 3, 4, 4.1, 4.2 |   1  |    |
