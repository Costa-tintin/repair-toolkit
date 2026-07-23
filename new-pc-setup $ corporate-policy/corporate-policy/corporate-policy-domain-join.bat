@echo off
TITLE Corporate Policy and Domain Join Tool v1.0
color 0e
setlocal enabledelayedexpansion

:: ============================================================
:: REPORT SETUP
:: ============================================================
set TIMESTAMP=%date:~-4,4%-%date:~-7,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%
set TIMESTAMP=%TIMESTAMP: =0%
set REPORT=%USERPROFILE%\Desktop\corporate-policy-log_%TIMESTAMP%.txt

echo ============================================================ > "%REPORT%"
echo CORPORATE POLICY AND DOMAIN JOIN LOG >> "%REPORT%"
echo Generated : %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo User : %USERNAME% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"

echo ============================================================
echo CORPORATE POLICY AND DOMAIN JOIN TOOL v1.0
echo ============================================================
echo.
echo This tool will:
echo [1] Show current domain/workgroup status
echo [2] Apply and verify Group Policy
echo [3] Show user roles and group memberships
echo [4] List available scheduled tasks
echo [5] Map shared network drives
echo [6] Show applied policies report
echo.
timeout /t 3 > nul

:: ============================================================
:: SECTION 1 — CURRENT DOMAIN STATUS
:: ============================================================
echo [1/6] Checking current domain and workgroup status...
echo ============================================================ >> "%REPORT%"
echo SECTION 1 — CURRENT DOMAIN AND WORKGROUP STATUS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
wmic computersystem get Name, Domain, Workgroup, PartOfDomain >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Current User Identity --- >> "%REPORT%"
whoami /all >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Logged On Users --- >> "%REPORT%"
query user >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Domain status captured.

:: ============================================================
:: HOW TO JOIN A DOMAIN — STEPS LOGGED TO REPORT
:: ============================================================
echo ============================================================ >> "%REPORT%"
echo DOMAIN JOIN STEPS (run these manually or via script below) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo Step 1: Confirm the PC can reach the domain controller >> "%REPORT%"
echo ping ^<your-domain-controller-ip^> >> "%REPORT%"
echo. >> "%REPORT%"
echo Step 2: Set DNS to point to the domain controller >> "%REPORT%"
echo netsh interface ip set dns "Ethernet" static ^<DC-IP^> >> "%REPORT%"
echo. >> "%REPORT%"
echo Step 3: Join the domain via PowerShell (run as Admin): >> "%REPORT%"
echo Add-Computer -DomainName "yourdomain.local" -Credential yourdomain\adminuser -Restart >> "%REPORT%"
echo. >> "%REPORT%"
echo Step 4: Or via GUI: >> "%REPORT%"
echo System Properties ^> Computer Name ^> Change ^> Domain >> "%REPORT%"
echo Enter domain name ^> enter domain admin credentials ^> OK ^> Restart >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: SECTION 2 — APPLY AND VERIFY GROUP POLICY
:: ============================================================
echo.
echo [2/6] Applying Group Policy...
echo ============================================================ >> "%REPORT%"
echo SECTION 2 — GROUP POLICY >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- Forcing Group Policy Update --- >> "%REPORT%"
gpupdate /force >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Group Policy Results (this machine) --- >> "%REPORT%"
gpresult /r >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Applied GPO List --- >> "%REPORT%"
gpresult /scope computer /v >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Group Policy applied and verified.

:: ============================================================
:: SECTION 3 — USER ROLES AND GROUP MEMBERSHIPS
:: ============================================================
echo.
echo [3/6] Auditing user roles and group memberships...
echo ============================================================ >> "%REPORT%"
echo SECTION 3 — USER ROLES AND GROUP MEMBERSHIPS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- Local Groups --- >> "%REPORT%"
net localgroup >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Administrators Group Members --- >> "%REPORT%"
net localgroup administrators >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Remote Desktop Users --- >> "%REPORT%"
net localgroup "Remote Desktop Users" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- All Local User Accounts --- >> "%REPORT%"
net user >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Current User Group Memberships --- >> "%REPORT%"
whoami /groups >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- User Rights and Privileges --- >> "%REPORT%"
whoami /priv >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] User roles and groups captured.

:: ============================================================
:: SECTION 3B — HOW TO ADD A USER ROLE (LOGGED AS REFERENCE)
:: ============================================================
echo ============================================================ >> "%REPORT%"
echo SECTION 3B — HOW TO ASSIGN USER ROLES (REFERENCE) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo TO ADD A USER TO ADMINISTRATORS: >> "%REPORT%"
echo net localgroup administrators "DOMAIN\username" /add >> "%REPORT%"
echo. >> "%REPORT%"
echo TO ADD A USER TO REMOTE DESKTOP USERS: >> "%REPORT%"
echo net localgroup "Remote Desktop Users" "DOMAIN\username" /add >> "%REPORT%"
echo. >> "%REPORT%"
echo TO CREATE A NEW LOCAL USER: >> "%REPORT%"
echo net user "newusername" "Password123!" /add >> "%REPORT%"
echo. >> "%REPORT%"
echo TO SET A USER PASSWORD TO NEVER EXPIRE: >> "%REPORT%"
echo wmic useraccount where "Name='username'" set PasswordExpires=FALSE >> "%REPORT%"
echo. >> "%REPORT%"
echo TO DISABLE A USER ACCOUNT: >> "%REPORT%"
echo net user "username" /active:no >> "%REPORT%"
echo. >> "%REPORT%"
echo TO ENABLE A USER ACCOUNT: >> "%REPORT%"
echo net user "username" /active:yes >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: SECTION 4 — AVAILABLE SCHEDULED TASKS
:: ============================================================
echo.
echo [4/6] Listing available scheduled tasks...
echo ============================================================ >> "%REPORT%"
echo SECTION 4 — SCHEDULED TASKS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- All Scheduled Tasks (summary) --- >> "%REPORT%"
schtasks /query /fo TABLE >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Ready Tasks Only --- >> "%REPORT%"
schtasks /query /fo TABLE | findstr "Ready" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo --- Running Tasks Right Now --- >> "%REPORT%"
schtasks /query /fo TABLE | findstr "Running" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo [OK] Scheduled tasks listed.

:: ============================================================
:: SECTION 4B — HOW TO CREATE A SCHEDULED TASK (REFERENCE)
:: ============================================================
echo ============================================================ >> "%REPORT%"
echo SECTION 4B — HOW TO CREATE SCHEDULED TASKS (REFERENCE) >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo TO RUN A SCRIPT DAILY AT 8AM: >> "%REPORT%"
echo schtasks /create /tn "DailyRepairCheck" /tr "C:\tools\repair-toolkit.bat" /sc daily /st 08:00 /ru SYSTEM >> "%REPORT%"
echo. >> "%REPORT%"
echo TO RUN A SCRIPT AT EVERY STARTUP: >> "%REPORT%"
echo schtasks /create /tn "StartupCheck" /tr "C:\tools\repair-toolkit.bat" /sc onstart /ru SYSTEM >> "%REPORT%"
echo. >> "%REPORT%"
echo TO RUN A SCRIPT AT USER LOGIN: >> "%REPORT%"
echo schtasks /create /tn "LoginAudit" /tr "C:\tools\pc-security-audit.bat" /sc onlogon /ru SYSTEM >> "%REPORT%"
echo. >> "%REPORT%"
echo TO DELETE A TASK: >> "%REPORT%"
echo schtasks /delete /tn "TaskName" /f >> "%REPORT%"
echo. >> "%REPORT%"
echo TO RUN A TASK IMMEDIATELY: >> "%REPORT%"
echo schtasks /run /tn "TaskName" >> "%REPORT%"
echo. >> "%REPORT%"

:: ============================================================
:: SECTION 5 — MAP NETWORK DRIVES
:: ============================================================
echo.
echo [5/6] Checking and mapping network drives...
echo ============================================================ >> "%REPORT%"
echo SECTION 5 — NETWORK DRIVES >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo --- Currently Mapped Drives --- >> "%REPORT%"
net use >> "%REPORT%" 2>&1
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo NETWORK DRIVE MAPPING REFERENCE >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo TO MAP A NETWORK DRIVE PERMANENTLY: >> "%REPORT%"
echo net use Z: \\server\sharename /persistent:yes >> "%REPORT%"
echo. >> "%REPORT%"
echo TO MAP WITH CREDENTIALS: >> "%REPORT%"
echo net use Z: \\server\sharename /user:DOMAIN\username Password123! /persistent:yes >> "%REPORT%"
echo. >> "%REPORT%"
echo TO DISCONNECT A MAPPED DRIVE: >> "%REPORT%"
echo net use Z: /delete >> "%REPORT%"
echo. >> "%REPORT%"
echo TO DISCONNECT ALL MAPPED DRIVES: >> "%REPORT%"
echo net use * /delete /y >> "%REPORT%"
echo. >> "%REPORT%"
echo [OK] Network drives checked.

:: ============================================================
:: SECTION 6 — FULL POLICY RESULTS REPORT
:: ============================================================
echo.
echo [6/6] Generating full policy results report...
echo ============================================================ >> "%REPORT%"
echo SECTION 6 — FULL GROUP POLICY RESULTS >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
gpresult /h "%USERPROFILE%\Desktop\GPO-Report_%TIMESTAMP%.html" >> "%REPORT%" 2>&1
echo GPO HTML report saved to Desktop as GPO-Report_%TIMESTAMP%.html >> "%REPORT%"
echo Open the .html file in a browser for a full formatted GPO view. >> "%REPORT%"
echo. >> "%REPORT%"
echo --- Applied Security Settings --- >> "%REPORT%"
secedit /export /cfg "%USERPROFILE%\Desktop\security-policy_%TIMESTAMP%.cfg" >> "%REPORT%" 2>&1
echo Security policy exported to Desktop as security-policy_%TIMESTAMP%.cfg >> "%REPORT%"
echo. >> "%REPORT%"
echo [OK] Policy reports generated.

:: ============================================================
:: FINAL SUMMARY
:: ============================================================
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo CORPORATE POLICY SETUP COMPLETE >> "%REPORT%"
echo Finished : %date% %time% >> "%REPORT%"
echo Computer : %COMPUTERNAME% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"
echo FILES SAVED TO YOUR DESKTOP: >> "%REPORT%"
echo corporate-policy-log_%TIMESTAMP%.txt ^<-- this log >> "%REPORT%"
echo GPO-Report_%TIMESTAMP%.html ^<-- open in browser >> "%REPORT%"
echo security-policy_%TIMESTAMP%.cfg ^<-- security settings >> "%REPORT%"
echo. >> "%REPORT%"
echo FINAL CHECKLIST BEFORE HANDING TO USER: >> "%REPORT%"
echo [ ] Machine joined to domain and restarted >> "%REPORT%"
echo [ ] Correct user account created or linked >> "%REPORT%"
echo [ ] User added to correct group (Administrators / Standard) >> "%REPORT%"
echo [ ] Group Policy applied: gpupdate /force run >> "%REPORT%"
echo [ ] Network drives mapped and accessible >> "%REPORT%"
echo [ ] Shared printers visible and set as default >> "%REPORT%"
echo [ ] User tested login with their own credentials >> "%REPORT%"
echo [ ] Defender active and signatures up to date >> "%REPORT%"
echo [ ] Firewall on for all profiles >> "%REPORT%"

echo.
echo ============================================================
echo CORPORATE POLICY SETUP COMPLETE
echo ============================================================
echo.
echo 3 files saved to your Desktop:
echo 1. corporate-policy-log_%TIMESTAMP%.txt
echo 2. GPO-Report_%TIMESTAMP%.html (open in browser)
echo 3. security-policy_%TIMESTAMP%.cfg
echo ============================================================
echo.
PAUSE
