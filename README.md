# DESCRIPTION

This program offers a few functionalities to pair with a PdaNet setup.
If the "AutoHotspot" switch in the modemConfig.cfg file equals 1, it will Force the computer to silently 


| Config File Command   |      Section      |  Value Range | Default Value | Description |
|-----------------------|:-----------------:|-------------:|--------------:|------------:|
| AutoHotspot |                    SWITCHES       |   0-1 |             1  |   If equals 1, runs a timer thread that executes a powershell script to force a Windows Hotspot open, and periodically re-runs that script to keep it open. Automatically launches a secondary timer thread that closes powershell instances left open in the background. |
| AutoConnect |                    SWITCHES       |   0-1 |             1  |   If equals 1, runs a function to check if the computer is connected to the internet currently, and if it is not, it will attempt to force PdaNet to reconnect to the phone. (Used to ensure that when PdaNet connection disconnects randomly, it will reconnect itself. Will not be able to force the phone to turn PdaNet USB tethering on, though, but thankfully that is a very rare thing to turn itself off.) |
| DoubleCleanupPass |              SWITCHES       |   0-1 |             1  |   HotSpotCleanupThread |
| HotspotAdapterSetAutoDHCP |      SWITCHES       |   0-1 |             1  |    |
| AutoConnectSpeed |      CONFIG                  |   N/A |         14000  |    |
| AutoConnectDeleteTestSpeed |    CONFIG          |   N/A |    |    |
| HotspotExecSpeed |      CONFIG                  |   N/A |    |    |
| HotspotCleanupSpeed |      CONFIG               |   N/A |    |    |
| HotspotAdapterName |      CONFIG                |   N/A |    |    |
| HotspotAdapterDHCPbat |      CONFIG             |   N/A |    |    |
| Container |      PDANET                         |    $1 |    |    |
| Executable |      PDANET                        |    $1 |    |    |
| DismissPdaMessages |      PDANET                |    $1 |    |    |
| DismissMessageSpeed |      PDANET               |    $1 |    |    |
| AppTitleRoot |      ENGINE                      |    $1 |    |    |
| Debugger |      DEBUG                           |    $1 |    |    |
| DebuggerLevel |      DEBUG                      |    1, 2, 3, 4, 4.1, 4.2 |  1  |    |
