@echo off
TITLE IT Technician Repair Toolkit v2.0
color 0a
setlocal enabledelayedexpansion

:: ============================================================
:: SET REPORT FILE — saves to Desktop with timestamp
:: ============================================================
set TIMESTAMP=%date:~-4,4%-%date:~-7,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%
set TIMESTAMP=%TIMESTAMP: =0%
set REPORT=%USERPROFILE%\Desktop\repair-report_%TIMESTAMP%.txt

echo ============================================================ > "%REPORT%"
echo IT TECHNICIAN REPAIR REPORT >> "%REPORT%"
echo Generated: %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo User : %USERNAME% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"

echo ============================================================
echo IT TECHNICIAN REPAIR TOOLKIT v2.0
echo Report will be saved to your Desktop
echo ============================================================
echo.
timeout /t 2 > nul

:: ============================================================
:: SECTION 1 — SYSTEM INFORMATION
:: ============================================================
echo [1/10] Collecting system information...
echo ============================================================ >> "%REPORT%"
echo SECTION 1 — SYSTEM INFORMATION >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
systeminfo >> "%REPORT%"
echo. >> "%REPORT%"
echo [OK] System info collected.

:: ============================================================
:: SECTION 2 — WINDOWS SYSTEM FILE CHECK
:: ============================================================
echo.
echo [2/10] Scanning Windows system files (sfc /scannow)...
echo ============================================================ >> "%REPORT%"
echo SECTION 2 — SYSTEM FILE CHECK (SFC) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
sfc /scannow >> "%REPORT%" 2>&1
echo [OK] SFC scan complete.
echo SFC scan complete. >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: SECTION 3 — WINDOWS IMAGE REPAIR
:: ============================================================
echo.
echo [3/10] Repairing Windows image (DISM)...
echo ============================================================ >> "%REPORT%"
echo SECTION 3 — WINDOWS IMAGE REPAIR (DISM) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
DISM /Online /Cleanup-Image /RestoreHealth >> "%REPORT%" 2>&1
echo [OK] DISM repair complete.
echo DISM repair complete. >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: SECTION 4 — NETWORK DIAGNOSTICS
:: ============================================================
echo.
echo [4/10] Running network diagnostics...
echo ============================================================ >> "%REPORT%"
echo SECTION 4 — NETWORK DIAGNOSTICS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"

echo --- IP Configuration --- >> "%REPORT%"
ipconfig /all >> "%REPORT%"
echo. >> "%REPORT%"

echo --- DNS Cache (before flush) --- >> "%REPORT%"
ipconfig /displaydns >> "%REPORT%"
echo. >> "%REPORT%"

echo --- Flushing DNS Cache --- >> "%REPORT%"
ipconfig /flushdns >> "%REPORT%"
echo. >> "%REPORT%"

echo --- Ping Test (Google 8.8.8.8) --- >> "%REPORT%"
ping 8.8.8.8 -n 4 >> "%REPORT%"
echo. >> "%REPORT%"

echo --- Ping Test (Cloudflare 1.1.1.1) --- >> "%REPORT%"
ping 1.1.1.1 -n 4 >> "%REPORT%"
echo. >> "%REPORT%"

echo --- Traceroute to Google DNS --- >> "%REPORT%"
tracert -d -h 10 8.8.8.8 >> "%REPORT%"
echo. >> "%REPORT%"

echo --- Active Network Connections --- >> "%REPORT%"
netstat -ano >> "%REPORT%"
echo. >> "%REPORT%"

echo [OK] Network diagnostics complete.
echo Network diagnostics complete. >> "%REPORT%"

:: ============================================================
:: SECTION 5 — NETWORK RESET
:: ============================================================
echo.
echo [5/10] Resetting network stack...
echo ============================================================ >> "%REPORT%"
echo SECTION 5 — NETWORK RESET >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
netsh winsock reset >> "%REPORT%" 2>&1
netsh int ip reset >> "%REPORT%" 2>&1
ipconfig /release >> "%REPORT%" 2>&1
ipconfig /renew >> "%REPORT%" 2>&1
echo [OK] Network stack reset. A reboot may be needed to apply winsock changes.
echo Network stack reset complete. >> "%REPORT%"
echo NOTE: Reboot required to fully apply winsock reset. >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: SECTION 6 — DISK HEALTH
:: ============================================================
echo.
echo [6/10] Checking disk health...
echo ============================================================ >> "%REPORT%"
echo SECTION 6 — DISK HEALTH >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- CHKDSK Status (C:) --- >> "%REPORT%"
chkdsk C: >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Disk List (diskpart) --- >> "%REPORT%"
echo list disk | diskpart >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Disk health check complete.
echo Disk health check complete. >> "%REPORT%"

:: ============================================================
:: SECTION 7 — STARTUP PROGRAMS
:: ============================================================
echo.
echo [7/10] Listing startup programs...
echo ============================================================ >> "%REPORT%"
echo SECTION 7 — STARTUP PROGRAMS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wmic startup get Caption, Command, Location >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Startup programs listed.
echo Startup programs listed. >> "%REPORT%"

:: ============================================================
:: SECTION 8 — RUNNING PROCESSES
:: ============================================================
echo.
echo [8/10] Listing running processes...
echo ============================================================ >> "%REPORT%"
echo SECTION 8 — RUNNING PROCESSES >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
tasklist /v >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Process list captured.
echo Process list captured. >> "%REPORT%"

:: ============================================================
:: SECTION 9 — RECENT SYSTEM EVENT ERRORS
:: ============================================================
echo.
echo [9/10] Pulling recent System event errors...
echo ============================================================ >> "%REPORT%"
echo SECTION 9 — RECENT SYSTEM EVENT LOG ERRORS (last 50) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wevtutil qe System /c:50 /rd:true /f:text /q:"*[System[Level=2]]" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo SECTION 9B — RECENT APPLICATION EVENT LOG ERRORS (last 25) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wevtutil qe Application /c:25 /rd:true /f:text /q:"*[System[Level=2]]" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Event logs captured.
echo Event logs captured. >> "%REPORT%"

:: ============================================================
:: SECTION 10 — INSTALLED SOFTWARE LIST
:: ============================================================
echo.
echo [10/10] Listing installed software...
echo ============================================================ >> "%REPORT%"
echo SECTION 10 — INSTALLED SOFTWARE >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wmic product get Name, Version, InstallDate >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Software list captured.
echo Software list captured. >> "%REPORT%"

:: ============================================================
:: FINAL SUMMARY
:: ============================================================
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo REPAIR PROCESS COMPLETE >> "%REPORT%"
echo All sections finished: %date% %time% >> "%REPORT%"
echo Report saved to: %REPORT% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"

echo.
echo ============================================================
echo ALL CHECKS COMPLETE
echo ============================================================
echo.
echo Report saved to your Desktop:
echo repair-report_%TIMESTAMP%.txt
echo.
echo Open it in Notepad to review all findings.
echo ============================================================
echo.
PAUSE
