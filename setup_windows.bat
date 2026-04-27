@echo off
setlocal
cd /d "%~dp0"

set "PYTHON_EXE="

where py >nul 2>nul
if %ERRORLEVEL%==0 (
  set "PYTHON_EXE=py -3"
) else (
  where python >nul 2>nul
  if %ERRORLEVEL%==0 (
    set "PYTHON_EXE=python"
  )
)

if not defined PYTHON_EXE (
  echo [ERROR] Python 3 was not found in PATH.
  echo [INFO] Install Python 3.11+ and rerun this script.
  pause
  exit /b 1
)

if not exist ".venv" (
  echo [INFO] Creating virtual environment...
  call %PYTHON_EXE% -m venv .venv
  if errorlevel 1 exit /b 1
)

echo [INFO] Upgrading pip...
call ".\.venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 exit /b 1

echo [INFO] Installing Python dependencies...
call ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 exit /b 1

if not exist "logs" mkdir logs
if not exist "output" mkdir output
if not exist ".browser-profile" mkdir .browser-profile

echo [INFO] Setup complete.
echo [INFO] Next step: run start_manual_loop.bat
pause
exit /b 0
