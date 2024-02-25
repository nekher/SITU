@echo off
title SITU (Solucion a Internet Todo en Uno)

:menu
cls
echo.[0m
echo [31m*********************************************[0m
echo [31m**[0m [46m                                       [0m [31m**[0m
echo [31m**[0m [46m                                       [0m [31m**[0m
echo [31m**[0m [7;43m                 SITU                  [0m [31m**[0m
echo [31m**[0m [7;43m     Solucion Internet Todo en Uno     [0m [31m**[0m
echo [31m**[0m [46m                                       [0m [31m**[0m
echo [31m**[0m [46m                                       [0m [31m**[0m
echo [31m*********************************************[0m
echo [31m**[0m [94m       Script creado por NMRD - 2023[0m    [31m**[0m
echo [31m*********************************************[0m
echo.[31m**[0m                                         [31m**[0m
echo [31m**[0m            [1;4mELIJA UNA OPCION[0m             [31m**[0m
echo.[31m**[0m                                         [31m**[0m
echo [31m**[0m  [91m 1) INTERNET POR WIFI SIN PROXY[0m        [31m**[0m
echo [31m**[0m  [32m 2) INTERNET POR DOMINIO CON PROXY[0m     [31m**[0m
echo.[31m**[0m                                         [31m**[0m
echo.[31m**[0m                                         [31m**[0m
echo [31m**[0m  [91m3) PONER INTERNET LIBERADA + PROXY OFF[0m [31m**[0m
echo [31m**[0m  [32m4) VOLVER A INTERNET SEGURA + PROXY ON[0m [31m**[0m
echo.[31m**[0m                                         [31m**[0m
echo [31m**[0m  [33m5) PONER PROXY[0m                         [31m**[0m
echo [31m**[0m  [33m6) SACAR PROXY[0m                         [31m**[0m
echo [31m**[0m  [33m7) FLUSH-RENEW[0m                         [31m**[0m
echo [31m**[0m                                         [31m**[0m
echo [31m**[0m  8) [4mSalir[0m                               [31m**[0m
echo [31m**[0m                                         [31m**[0m
echo [31m*********************************************[0m
echo.
set /p opcion= [91mTU ELECCION ES:[0m [94m

if "%opcion%"=="1" goto WIFI
if "%opcion%"=="2" goto ETH
if "%opcion%"=="5" goto PROXYON
if "%opcion%"=="6" goto PROXYOFF
if "%opcion%"=="3" goto MANUAL
if "%opcion%"=="4" goto DHCP
if "%opcion%"=="7" goto FLUSH-RENEW
if "%opcion%"=="8" exit


:WIFI
netsh interface set interface "Ethernet" admin=disable
netsh interface set interface "Wi-Fi" admin=enable
echo Ethernet disabled and Wi-Fi enabled.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 
echo Se dio de baja la conexion Ethernet, se habilito el WIFI y se ha sacado el proxy correctamente.
pause
goto menu

:ETH
netsh interface set interface "Ethernet" admin=enable
netsh interface set interface "Wi-Fi" admin=disable
echo Wi-Fi disabled and Ethernet enabled.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "PROXY:PUERTO" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "<local>" /f >nul
echo Se Deshabilito el WIFI, se Habilito el Cable de red y se coloco el proxy correctamente.
pause

goto menu

:PROXYON
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "PROXY:PUERTO" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "<local>" /f >nul
echo Se ha puesto el proxy correctamente.
pause
goto menu

:PROXYOFF
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 
echo Se ha sacado el proxy correctamente.
pause 
goto menu

:manual
netsh interface ipv4 set address name="Ethernet" source=static address=127.0.0.1 mask=255.255.255.0 gateway=127.0.0.1
netsh interface ipv4 set dnsservers name="Ethernet" source=static address=127.0.0.1 validate=no
netsh interface ipv4 add dnsserver name="Ethernet" address=127.0.0.1 validate=no index=2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 
echo La conexión de red ha sido configurada manualmente y se elimino el proxy
pause >nul
goto menu

:dhcp
netsh interface ipv4 set address name="Ethernet" source=dhcp
netsh interface ipv4 set dnsservers name="Ethernet" source=dhcp
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "PROXY:PUERTO" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "<local>" /f >nul
echo La conexion de red ha sido configurada para obtener una direccion IP automaticamente y se habilito el proxy nuevamente
pause >nul
goto menu

:FLUSH-RENEW
echo Procederemos a realizar los pasos para limpiar y renovar la conexion que tenes en este momento. Cuando quieras comenzar, apreta una tecla...
pause >nul
ipconfig /release
ipconfig /renew
echo Acabamos de realizar los comandos RELEASE y RENEW. Ahora procederemos a realizar un FLUSHDNS, apreta una tecla para continuar.
pause >nul
ipconfig /flushdns
echo Acabamos de realizar el comando FLUSHDNS. Esto deberia dar por "arreglado" cualquier inconveniente con la configuracion de la red. Volvamos al menu!
pause >nul
goto menu

