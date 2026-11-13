@echo off
setlocal EnableExtensions
title NetReset 1.0
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 (
  echo.
  echo  NetReset needs administrator rights to change network settings.
  echo  Asking Windows now - press Yes on the blue box.
  echo.
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

:MENU
cls
echo.
echo   NetReset 1.0 - fix the Wi-Fi without digging through settings
echo   =============================================================
echo.
echo   1. Flush the DNS cache          safe, instant, fixes "site not found"
echo   2. Renew the IP address         brief disconnect, fixes bad DHCP leases
echo   3. Clear the ARP cache          safe, fixes "can reach nothing"
echo   4. Reset Winsock and TCP/IP     heavy, needs a restart
echo   5. Run the safe steps (1 + 3)   the usual first attempt
echo   6. Show current network config  read only
echo   0. Exit
echo.
set "choice="
set /p "choice=  Choose a number and press Enter: "

if "%choice%"=="1" goto DNS
if "%choice%"=="2" goto RENEW
if "%choice%"=="3" goto ARP
if "%choice%"=="4" goto WINSOCK
if "%choice%"=="5" goto SAFE
if "%choice%"=="6" goto SHOW
if "%choice%"=="0" goto END
goto MENU

:DNS
cls
echo.
echo  Flushing the DNS cache. This clears the record of which name points
echo  to which address, so Windows asks again. Nothing is deleted.
echo.
ipconfig /flushdns
echo.
echo  Done.
pause
goto MENU

:ARP
cls
echo.
echo  Clearing the ARP cache - the table of which device owns which local
echo  address. It rebuilds itself within seconds.
echo.
netsh interface ip delete arpcache >nul 2>&1
if %errorlevel% neq 0 (
  arp -d * >nul 2>&1
)
echo  Done.
pause
goto MENU

:RENEW
cls
echo.
echo  This releases your current IP address and asks the router for a new one.
echo  Your connection will drop for a few seconds. If you are on a static IP
echo  set up by hand, this can leave you offline - use option 1 instead.
echo.
set "ok="
set /p "ok=  Type YES to continue: "
if /i not "%ok%"=="YES" goto MENU
echo.
echo  Releasing...
ipconfig /release >nul 2>&1
echo  Renewing...
ipconfig /renew
echo.
echo  Done. If you are still offline, restart the router and try option 4.
pause
goto MENU

:WINSOCK
cls
echo.
echo  This resets the Windows network stack: Winsock catalog and the TCP/IP
echo  configuration. It is the standard fix for "connected but no internet"
echo  after a VPN, a proxy tool or a malware clean-up.
echo.
echo  It removes custom proxy and static IP settings on some machines, and
echo  it will NOT take effect until you restart.
echo.
set "ok="
set /p "ok=  Type YES to continue: "
if /i not "%ok%"=="YES" goto MENU
echo.
netsh winsock reset
netsh int ip reset
ipconfig /flushdns
echo.
echo  Done. Restart the computer for the reset to take effect.
pause
goto MENU

:SAFE
cls
echo.
echo  Running the two safe steps: flush DNS, clear ARP.
echo.
ipconfig /flushdns
netsh interface ip delete arpcache >nul 2>&1
if %errorlevel% neq 0 arp -d * >nul 2>&1
echo.
echo  Done. Try the browser again. If it is still broken, use option 4.
pause
goto MENU

:SHOW
cls
echo.
echo  Adapters
echo  --------
ipconfig /all
echo.
echo  Recent DNS lookups
echo  ------------------
ipconfig /displaydns | more
echo.
pause
goto MENU

:END
echo.
echo  Bye. Nothing else was changed.
timeout /t 2 >nul
exit /b 0
