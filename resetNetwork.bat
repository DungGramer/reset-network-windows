@echo off
color 8f
title Reset Network - DungGramer
cls
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo  Run CMD as Administrator...
    goto goUAC 
) else (
 goto goADMIN )

:goUAC
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:goADMIN
    pushd "%CD%"
    CD /D "%~dp0"

:begin
echo     ___                 
echo    / _ \__ _____  ___ _ 
echo   / // / // / _ \/ _ `/ 
echo  /____/\_,_/_//_/\_, / 
echo       _____     /___/ 
echo      / ___/______  __ _  ___ ____ 
echo     / (_ / __/ _ `/  ' \/ -_) __/
echo     \___/_/  \_,_/_/_/_/\__/_/     
echo.
echo Follow me: https://github.com/DungGramer/
echo.
echo 1. Reset Network
echo 2. Reset TCP - Windows 7
echo 3. Reset TCP - Windows 10
echo 4. Set static DNS - Google (8.8.8.8 - 8.8.4.4)
echo 5. Set static DNS - CloudFlare (1.1.1.1 - 1.0.0.1)
echo 6. Exit
Choice /N /C 123456 /M ">_ "%1
if ERRORLEVEL 6 goto :6 6
if ERRORLEVEL 5 goto :5 5
if ERRORLEVEL 4 goto :4 4
if ERRORLEVEL 3 goto :3 3
if ERRORLEVEL 2 goto :2 2
if ERRORLEVEL 1 goto :1 1


:1
netsh winsock reset
netsh int ip reset
netsh advfirewall reset
ipconfig /flushdns
ipconfig /release
ipconfig /renew
# Reset NAT Driver service
net stop winnat
net start winnat
# call :dns
pause
cls
goto begin
)

:2
netsh winsock reset
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set supplemental
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global congestionprovider=ctcp
netsh advfirewall firewall add rule name="StopThrottling" dir=in action=block remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes
pause
cls
goto begin
)

:3
netsh winsock reset
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh interface tcp set heuristics disabled
netsh advfirewall firewall add rule name="StopThrottling" dir=in action=block remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes
pause
cls
goto begin
)

:4
call :dns
netsh interface ipv4 add dnsserver "Local Area Connection" 8.8.8.8
netsh interface ipv4 add dnsserver "Local Area Connection" 8.8.4.4
netsh interface ipv4 add dnsserver "Local Area Connection 1" 8.8.8.8
netsh interface ipv4 add dnsserver "Local Area Connection 1" 8.8.4.4
netsh interface ipv4 add dnsserver "Wireless Network Connection" 8.8.8.8
netsh interface ipv4 add dnsserver "Wireless Network Connection" 8.8.4.4
netsh interface ipv4 add dnsserver "Wireless Network Connection 1" 8.8.8.8
netsh interface ipv4 add dnsserver "Wireless Network Connection 1" 8.8.4.4
netsh interface ipv4 add dnsserver "Ethernet" 8.8.8.8
netsh interface ipv4 add dnsserver "Ethernet" 8.8.4.4
netsh interface ipv4 add dnsserver "Ethernet 1" 8.8.8.8
netsh interface ipv4 add dnsserver "Ethernet 1" 8.8.4.4
netsh interface ipv4 add dnsserver "LAN" 8.8.8.8
netsh interface ipv4 add dnsserver "LAN" 8.8.4.4
netsh interface ipv4 add dnsserver "Wi-Fi" 8.8.8.8
netsh interface ipv4 add dnsserver "Wi-Fi" 8.8.4.4
netsh interface ipv4 add dnsserver "Wi-Fi 1" 8.8.8.8
netsh interface ipv4 add dnsserver "Wi-Fi 1" 8.8.4.4
pause
cls
goto begin
)

:5
call :dns
netsh interface ipv4 add dnsserver "Local Area Connection" 1.1.1.1
netsh interface ipv4 add dnsserver "Local Area Connection" 1.0.0.1
netsh interface ipv4 add dnsserver "Local Area Connection 1" 1.1.1.1
netsh interface ipv4 add dnsserver "Local Area Connection 1" 1.0.0.1
netsh interface ipv4 add dnsserver "Wireless Network Connection" 1.1.1.1
netsh interface ipv4 add dnsserver "Wireless Network Connection" 1.0.0.1
netsh interface ipv4 add dnsserver "Wireless Network Connection 1" 1.1.1.1
netsh interface ipv4 add dnsserver "Wireless Network Connection 1" 1.0.0.1
netsh interface ipv4 add dnsserver "Ethernet" 1.1.1.1
netsh interface ipv4 add dnsserver "Ethernet" 1.0.0.1
netsh interface ipv4 add dnsserver "Ethernet 1" 1.1.1.1
netsh interface ipv4 add dnsserver "Ethernet 1" 1.0.0.1
netsh interface ipv4 add dnsserver "LAN" 1.1.1.1
netsh interface ipv4 add dnsserver "LAN" 1.0.0.1
netsh interface ipv4 add dnsserver "Wi-Fi" 1.1.1.1
netsh interface ipv4 add dnsserver "Wi-Fi" 1.0.0.1
netsh interface ipv4 add dnsserver "Wi-Fi 1" 1.1.1.1
netsh interface ipv4 add dnsserver "Wi-Fi 1" 1.0.0.1
pause
cls
goto begin
)

:6
exit
)

:dns
netsh interface ip set dns "Local Area Connection" dhcp
netsh interface ip set address "Local Area Connection" dhcp
netsh interface ip set dns "Local Area Connection 1" dhcp
netsh interface ip set address "Local Area Connection 1" dhcp
netsh interface ip set dns "Wireless Network Connection" dhcp
netsh interface ip set address "Wireless Network Connection" dhcp
netsh interface ip set dns "Wireless Network Connection 1" dhcp
netsh interface ip set address "Wireless Network Connection 1" dhcp
netsh interface ip set dns "Ethernet" dhcp
netsh interface ip set address "Ethernet" dhcp
netsh interface ip set dns "Ethernet 1" dhcp
netsh interface ip set address "Ethernet 1" dhcp
netsh interface ip set dns "Wi-Fi" dhcp
netsh interface ip set address "Wi-Fi" dhcp
netsh interface ip set dns "Wi-Fi 1" dhcp
netsh interface ip set address "Wi-Fi 1" dhcp
netsh interface ip set dns "LAN" dhcp
netsh interface ip set address "LAN" dhcp
goto :eof
)
