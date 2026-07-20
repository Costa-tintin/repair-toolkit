# pc-security-audit

A Windows security audit tool for IT technicians. Run it on any Windows
machine as Administrator — it checks 10 security areas and saves a
timestamped report to the Desktop.

---

## What It Checks

| Step | Check | What to Look For |
|---|---|---|
| 1 | Windows Firewall | ON for all 3 profiles (Domain/Private/Public) |
| 2 | Open ports | Any unexpected LISTENING ports |
| 3 | Local user accounts | Unknown accounts in Administrators group |
| 4 | Password policy | Expiry and complexity enforced |
| 5 | Windows Defender | Active, real-time protection on, signatures recent |
| 6 | Startup entries + registry Run keys | Unknown programs set to auto-run |
| 7 | Shared folders | Unexpected shares visible on the network |
| 8 | Windows Update history | Missing recent patches |
| 9 | Remote access settings | RDP/WinRM on when they shouldn't be |
| 10 | Failed login events | Repeated failures = brute force attempt |

---

## Output

Every run saves a report to the Desktop named:
