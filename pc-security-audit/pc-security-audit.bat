@echo off
TITLE PC Security Audit Tool v1.0
color 0c
setlocal enabledelayedexpansion

:: ============================================================
:: REPORT SETUP
:: ============================================================
set TIMESTAMP=%date:~-4,4%-%date:~-7,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%
set TIMESTAMP=%TIMESTAMP: =0%
set REPORT=%USERPROFILE%\Desktop\security-audit_%TIMESTAMP%.txt

echo ============================================================ > "%REPORT%"
echo PC SECURITY AUDIT REPORT >> "%REPORT%"
echo Generated : %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo User : %USERNAME% >> "%REPORT%"
echo Domain : %USERDOMAIN% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"

echo ============================================================
echo PC SECURITY AUDIT TOOL v1.0
echo Report will be saved to your Desktop
echo ============================================================
echo.
timeout /t 2 > nul

:: ============================================================
:: SECTION 1 — WINDOWS FIREWALL STATUS
:: ============================================================
echo [1/10] Checking Windows Firewall...
echo ============================================================ >> "%REPORT%"
echo SECTION 1 — WINDOWS FIREWALL STATUS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
netsh advfirewall show allprofiles >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Firewall status captured.

:: ============================================================
:: SECTION 2 — OPEN PORTS AND LISTENING SERVICES
:: ============================================================
echo.
echo [2/10] Scanning open ports and listening services...
echo ============================================================ >> "%REPORT%"
echo SECTION 2 — OPEN PORTS AND LISTENING SERVICES >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
netstat -ano | findstr "LISTENING" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Port-to-Process Mapping --- >> "%REPORT%"
netstat -ab >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Open ports captured.

:: ============================================================
:: SECTION 3 — LOCAL USER ACCOUNTS
:: ============================================================
echo.
echo [3/10] Listing local user accounts...
echo ============================================================ >> "%REPORT%"
echo SECTION 3 — LOCAL USER ACCOUNTS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- All Local Users --- >> "%REPORT%"
net user >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Administrator Group Members --- >> "%REPORT%"
net localgroup administrators >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Guest Account Status --- >> "%REPORT%"
net user guest >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] User accounts listed.

:: ============================================================
:: SECTION 4 — PASSWORD POLICY
:: ============================================================
echo.
echo [4/10] Checking password policy...
echo ============================================================ >> "%REPORT%"
echo SECTION 4 — PASSWORD AND ACCOUNT POLICY >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
net accounts >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Password policy captured.

:: ============================================================
:: SECTION 5 — WINDOWS DEFENDER STATUS
:: ============================================================
echo.
echo [5/10] Checking Windows Defender...
echo ============================================================ >> "%REPORT%"
echo SECTION 5 — WINDOWS DEFENDER STATUS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
powershell -command "Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, RealTimeProtectionEnabled, AntivirusSignatureLastUpdated, QuickScanStartTime, FullScanStartTime | Format-List" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Recent Threats Detected --- >> "%REPORT%"
powershell -command "Get-MpThreatDetection | Select-Object -First 20 | Format-List" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Defender status captured.

:: ============================================================
:: SECTION 6 — STARTUP PROGRAMS (SECURITY FOCUS)
:: ============================================================
echo.
echo [6/10] Auditing startup entries...
echo ============================================================ >> "%REPORT%"
echo SECTION 6 — STARTUP PROGRAMS AND REGISTRY RUN KEYS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- HKLM Run Key --- >> "%REPORT%"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- HKCU Run Key --- >> "%REPORT%"
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Scheduled Tasks (non-Microsoft) --- >> "%REPORT%"
schtasks /query /fo LIST /v | findstr /i /v "microsoft" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Startup entries audited.

:: ============================================================
:: SECTION 7 — SHARED FOLDERS
:: ============================================================
echo.
echo [7/10] Checking shared folders...
echo ============================================================ >> "%REPORT%"
echo SECTION 7 — SHARED FOLDERS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
net share >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Shared folders listed.

:: ============================================================
:: SECTION 8 — WINDOWS UPDATE STATUS
:: ============================================================
echo.
echo [8/10] Checking Windows Update history...
echo ============================================================ >> "%REPORT%"
echo SECTION 8 — WINDOWS UPDATE STATUS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
powershell -command "Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 20 | Format-Table HotFixID, Description, InstalledOn -AutoSize" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Update history captured.

:: ============================================================
:: SECTION 9 — REMOTE DESKTOP AND REMOTE SERVICES
:: ============================================================
echo.
echo [9/10] Checking remote access settings...
echo ============================================================ >> "%REPORT%"
echo SECTION 9 — REMOTE ACCESS SETTINGS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- Remote Desktop Status --- >> "%REPORT%"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections >> "%REPORT%" 2>&1
echo (0 = RDP Enabled, 1 = RDP Disabled) >> "%REPORT%"
echo. >> "%REPORT%"
echo --- Remote Registry Service --- >> "%REPORT%"
sc query RemoteRegistry >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- WinRM (Remote Management) --- >> "%REPORT%"
sc query WinRM >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Remote access settings captured.

:: ============================================================
:: SECTION 10 — SECURITY EVENT LOG (FAILED LOGINS)
:: ============================================================
echo.
echo [10/10] Pulling failed login attempts...
echo ============================================================ >> "%REPORT%"
echo SECTION 10 — FAILED LOGIN ATTEMPTS (last 30 events) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wevtutil qe Security /c:30 /rd:true /f:text /q:"*[System[EventID=4625]]" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Successful Logins (last 20) --- >> "%REPORT%"
wevtutil qe Security /c:20 /rd:true /f:text /q:"*[System[EventID=4624]]" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Security events captured.

:: ============================================================
:: SUMMARY
:: ============================================================
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo SECURITY AUDIT COMPLETE >> "%REPORT%"
echo Finished : %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo QUICK REVIEW GUIDE: >> "%REPORT%"
echo SECTION 1 - Is the firewall ON for all profiles? >> "%REPORT%"
echo SECTION 2 - Any unexpected ports LISTENING? >> "%REPORT%"
echo SECTION 3 - Any unknown accounts in Administrators group? >> "%REPORT%"
echo SECTION 4 - Is password expiry and complexity enforced? >> "%REPORT%"
echo SECTION 5 - Is Defender active and signatures recent? >> "%REPORT%"
echo SECTION 6 - Any unknown startup entries or tasks? >> "%REPORT%"
echo SECTION 7 - Any unexpected shared folders? >> "%REPORT%"
echo SECTION 8 - Is the machine missing recent updates? >> "%REPORT%"
echo SECTION 9 - Is RDP on when it shouldn't be? >> "%REPORT%"
echo SECTION 10 - Any repeated failed login attempts? >> "%REPORT%"

echo.
echo ============================================================
echo SECURITY AUDIT COMPLETE
echo ============================================================
echo.
echo Report saved to Desktop:
echo security-audit_%TIMESTAMP%.txt
echo.
echo Open it and search each SECTION number to review findings.
echo ============================================================
echo.
PAUSE
