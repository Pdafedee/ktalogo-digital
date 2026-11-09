@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Ktalogo-Dgital · Servidor web (PC + celular + tablet)
cd /d "%~dp0"
set "PORT=8550"
if not "%~1"=="" set "PORT=%~1"

echo ============================================================
echo  Ktalogo-Dgital · SERVIDOR WEB
echo  Un solo servidor, TODOS tus dispositivos:
echo    · Esta computadora : se abre solo en el navegador
echo    · Celular / tablet : usa la direccion IPv4 de abajo
echo                         (deben estar en la MISMA red Wi-Fi)
echo ============================================================

REM Usa el entorno virtual del instalador; si no existe, Python del sistema
set "PY=.venv\Scripts\python.exe"
if not exist "%PY%" set "PY=python"

for /d /r %%d in (__pycache__) do @if exist "%%d" rd /s /q "%%d"

echo.
echo  Direcciones para el celular (elige la de tu red Wi-Fi^):
echo.
ipconfig | findstr /i "IPv4"
echo.
echo  Abre en el celular:  http://LA-IP-DE-ARRIBA:%PORT%
echo  (tambien se abrira un CODIGO QR: apuntale con la camara
echo   del celular y entra sin escribir ninguna direccion^)
echo ============================================================
echo.

"%PY%" main.py --web --port %PORT%
if errorlevel 1 (
    echo.
    echo [!] El servidor termino con error. Revisa el mensaje de arriba.
    echo     Si el puerto esta ocupado prueba: INICIAR-WEB.bat 8551
    pause
)
endlocal
