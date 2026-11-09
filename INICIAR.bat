@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Ktalogo-Dgital · Escritorio
cd /d "%~dp0"

echo ============================================================
echo  Ktalogo-Dgital · inicio en modo escritorio
echo ============================================================

REM Usa el entorno virtual del instalador; si no existe, Python del sistema
set "PY=.venv\Scripts\python.exe"
if not exist "%PY%" set "PY=python"

REM Limpia cachés de bytecode obsoletas (evita errores tras actualizar)
for /d /r %%d in (__pycache__) do @if exist "%%d" rd /s /q "%%d"

"%PY%" scripts\doctor.py
if errorlevel 1 (
    echo.
    echo [!] El Doctor detecto problemas (revisalos arriba^).
    choice /c SN /n /m "Iniciar de todas formas? [S/N]: "
    if errorlevel 2 exit /b 1
)

echo.
"%PY%" main.py
if errorlevel 1 (
    echo.
    echo [!] La aplicacion termino con error. Revisa el mensaje de arriba.
    echo     Diagnostico rapido: doble clic en VERIFICAR (scripts\verificar.bat^)
    echo     o reinstala con INSTALAR.bat
    pause
)
endlocal
