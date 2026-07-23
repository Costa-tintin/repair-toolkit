# new-pc-setup

A two-script Windows toolkit for IT technicians setting up a fresh
machine to corporate standard. Run both scripts in order — setup first,
then corporate policy. Every step saves a timestamped log to the Desktop.

---

## Scripts in This Repo

| File | Purpose | Run Order |
|------|---------|-----------|
| `new-pc-setup.bat` | Configure hardware, security and baseline settings | First |
| `corporate-policy.bat` | Join domain, apply Group Policy, assign user roles, map drives | Second |

---

## new-pc-setup.bat — What It Does

| Step | Action |
|------|--------|
| 1 | Capture full system information snapshot |
| 2 | Set power plan to High Performance |
| 3 | Disable Fast Startup |
| 4 | Set timezone (East Africa Standard Time — edit to match your region) |
| 5 | Enable Windows Firewall on all profiles |
| 6 | Enable Windows Defender real-time protection |
| 7 | Check Windows Update history |
| 8 | Audit startup programs and registry Run keys |
| 9 | Capture full network configuration and flush DNS |
| 10 | Check domain/workgroup status |
| 11 | Audit local user accounts and password policy |
| 12 | Disk and system health baseline (chkdsk + sfc) |

**Output:** `new-pc-setup-log_YYYY-MM-DD_HH-MM.txt` saved to Desktop.

---

## corporate-policy.bat — What It Does

| Step | Action |
|------|--------|
| 1 | Show current domain/workgroup status |
| 2 | Force Group Policy update and capture full GPO results |
| 3 | Audit user roles, local groups, and current user privileges |
| 4 | List all scheduled tasks (ready, running, disabled) |
| 5 | Check and map network drives |
| 6 | Export full GPO report (HTML) and security policy config |

**Output — 3 files saved to Desktop:**

| File | Open With |
|------|-----------|
| `corporate-policy-log_YYYY-MM-DD_HH-MM.txt` | Notepad |
| `GPO-Report_YYYY-MM-DD_HH-MM.html` | Browser |
| `security-policy_YYYY-MM-DD_HH-MM.cfg` | Notepad |

---

## How to Use

### Step 1 — Run new-pc-setup.bat
1. Save `new-pc-setup.bat` to the machine.
2. Right-click > **Run as administrator**.
3. Wait for all 12 steps to complete.
4. Review the log on the Desktop.

### Step 2 — Join the domain manually (if not already joined)
System Properties > Computer Name > Change > Domain
Enter: yourdomain.local
Enter domain admin credentials when prompted
Restart the machine

Or via PowerShell:
```powershell
Add-Computer -DomainName "yourdomain.local" -Credential yourdomain\adminuser -Restart

Step 3 — Run corporate-policy.bat after the restart
Right-click > Run as administrator.
Wait for all 6 steps to complete.
Open GPO-Report.html in a browser for the full formatted policy view.
