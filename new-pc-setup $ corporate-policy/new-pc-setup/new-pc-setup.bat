@echo off
TITLE New PC Setup Tool v1.0
color 0b
setlocal enabledelayedexpansion

:: ============================================================
:: REPORT SETUP
:: ============================================================
set TIMESTAMP=%date:~-4,4%-%date:~-7,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%
set TIMESTAMP=%TIMESTAMP: =0%
set REPORT=%USERPROFILE%\Desktop\new-pc-setup-log_%TIMESTAMP%.txt

echo ============================================================ > "%REPORT%"
echo NEW PC SETUP LOG >> "%REPORT%"
echo Generated : %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo User : %USERNAME% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"

echo ============================================================
echo NEW PC SETUP TOOL v1.0
echo Configuring machine to IT standard...
echo Log will be saved to your Desktop
echo ============================================================
echo.
timeout /t 2 > nul

:: ============================================================
:: SECTION 1 — SYSTEM INFORMATION SNAPSHOT
:: ============================================================
echo [1/12] Capturing system information...
echo ============================================================ >> "%REPORT%"
echo SECTION 1 — SYSTEM INFORMATION SNAPSHOT >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
systeminfo >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] System snapshot saved.

:: ============================================================
:: SECTION 2 — SET POWER PLAN TO HIGH PERFORMANCE
:: ============================================================
echo.
echo [2/12] Setting power plan to High Performance...
echo ============================================================ >> "%REPORT%"
echo SECTION 2 — POWER PLAN >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >> "%REPORT%" 2>&1
powercfg /list >> "%REPORT%" 2>&1
echo Power plan set to High Performance. >> "%REPORT%"
echo. >> "%REPORT%"
echo [OK] Power plan configured.

:: ============================================================
:: SECTION 3 — DISABLE FAST STARTUP
:: ============================================================
echo.
echo [3/12] Disabling Fast Startup...
echo ============================================================ >> "%REPORT%"
echo SECTION 3 — FAST STARTUP >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >> "%REPORT%" 2>&1
echo Fast Startup disabled. >> "%REPORT%"
echo. >> "%REPORT%"
echo [OK] Fast Startup disabled.

:: ============================================================
:: SECTION 4 — SET TIMEZONE
:: ============================================================
echo.
echo [4/12] Setting timezone...
echo ============================================================ >> "%REPORT%"
echo SECTION 4 — TIMEZONE >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
:: Change the timezone string below to match your region
:: Examples: "E. Africa Standard Time" / "GMT Standard Time" / "South Africa Standard Time"
tzutil /s "E. Africa Standard Time"
tzutil /g >> "%REPORT%" 2>&1
echo Timezone set. >> "%REPORT%"
echo. >> "%REPORT%"
echo [OK] Timezone configured.

:: ============================================================
:: SECTION 5 — ENABLE FIREWALL ON ALL PROFILES
:: ============================================================
echo.
echo [5/12] Enabling Windows Firewall on all profiles...
echo ============================================================ >> "%REPORT%"
echo SECTION 5 — WINDOWS FIREWALL >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
netsh advfirewall set allprofiles state on >> "%REPORT%" 2>&1
netsh advfirewall show allprofiles >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Firewall enabled on all profiles.

:: ============================================================
:: SECTION 6 — ENABLE WINDOWS DEFENDER REAL-TIME PROTECTION
:: ============================================================
echo.
echo [6/12] Enabling Windows Defender real-time protection...
echo ============================================================ >> "%REPORT%"
echo SECTION 6 — WINDOWS DEFENDER >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $false" >> "%REPORT%" 2>&1
powershell -command "Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusEnabled, AntivirusSignatureLastUpdated | Format-List" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Defender real-time protection enabled.

:: ============================================================
:: SECTION 7 — WINDOWS UPDATE
:: ============================================================
echo.
echo [7/12] Checking Windows Update status...
echo ============================================================ >> "%REPORT%"
echo SECTION 7 — WINDOWS UPDATE >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
powershell -command "Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10 | Format-Table HotFixID, Description, InstalledOn -AutoSize" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Update history captured.

:: ============================================================
:: SECTION 8 — DISABLE UNNECESSARY STARTUP ITEMS
:: ============================================================
echo.
echo [8/12] Auditing startup items...
echo ============================================================ >> "%REPORT%"
echo SECTION 8 — STARTUP ITEMS AUDIT >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- Current Startup Programs --- >> "%REPORT%"
wmic startup get Caption, Command, Location >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Run Registry Keys (HKLM) --- >> "%REPORT%"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Run Registry Keys (HKCU) --- >> "%REPORT%"
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Startup items listed for review.

:: ============================================================
:: SECTION 9 — NETWORK CONFIGURATION
:: ============================================================
echo.
echo [9/12] Capturing network configuration...
echo ============================================================ >> "%REPORT%"
echo SECTION 9 — NETWORK CONFIGURATION >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
ipconfig /all >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Flushing DNS --- >> "%REPORT%"
ipconfig /flushdns >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Connectivity Test --- >> "%REPORT%"
ping 8.8.8.8 -n 4 >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Network configuration captured.

:: ============================================================
:: SECTION 10 — DOMAIN JOIN CHECK
:: ============================================================
echo.
echo [10/12] Checking domain status...
echo ============================================================ >> "%REPORT%"
echo SECTION 10 — DOMAIN AND WORKGROUP STATUS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wmic computersystem get Name, Domain, Workgroup, PartOfDomain >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Current Logged-on User --- >> "%REPORT%"
whoami /all >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Domain status captured.

:: ============================================================
:: SECTION 11 — LOCAL USER ACCOUNT SETUP
:: ============================================================
echo.
echo [11/12] Auditing local user accounts...
echo ============================================================ >> "%REPORT%"
echo SECTION 11 — LOCAL USER ACCOUNTS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- All Local Users --- >> "%REPORT%"
net user >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Administrators Group --- >> "%REPORT%"
net localgroup administrators >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Password Policy --- >> "%REPORT%"
net accounts >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] User accounts audited.

:: ============================================================
:: SECTION 12 — DISK AND SYSTEM HEALTH BASELINE
:: ============================================================
echo.
echo [12/12] Running system and disk health baseline...
echo ============================================================ >> "%REPORT%"
echo SECTION 12 — DISK AND SYSTEM HEALTH BASELINE >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- Disk Status --- >> "%REPORT%"
chkdsk C: >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- System File Check --- >> "%REPORT%"
sfc /verifyonly >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Installed Software List --- >> "%REPORT%"
wmic product get Name, Version, InstallDate >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] System health baseline captured.

:: ============================================================
:: SETUP COMPLETE SUMMARY
:: ============================================================
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo SETUP COMPLETE SUMMARY >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo Power Plan : High Performance >> "%REPORT%"
echo Fast Startup : Disabled >> "%REPORT%"
echo Timezone : E. Africa Standard Time >> "%REPORT%"
echo Firewall : Enabled - All Profiles >> "%REPORT%"
echo Defender : Real-time Protection ON >> "%REPORT%"
echo DNS Cache : Flushed >> "%REPORT%"
echo Completed : %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo Report saved to : Desktop >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo NEXT STEPS — CHECK BEFORE HANDING TO USER: >> "%REPORT%"
echo [ ] Join machine to domain (see corporate-policy.bat) >> "%REPORT%"
echo [ ] Assign correct user role in Active Directory >> "%REPORT%"
echo [ ] Apply Group Policy: gpupdate /force >> "%REPORT%"
echo [ ] Install required software for this department >> "%REPORT%"
echo [ ] Create or link the correct user account >> "%REPORT%"
echo [ ] Test login with the end user's credentials >> "%REPORT%"
echo [ ] Confirm shared drives and printers map correctly >> "%REPORT%"

echo.
echo ============================================================
echo SETUP COMPLETE
echo ============================================================
echo.
echo Log saved to Desktop:
echo new-pc-setup-log_%TIMESTAMP%.txt
echo.
echo Review the log then run corporate-policy.bat
echo to join the domain and apply Group Policy.
echo ============================================================
echo.
PAUSE
