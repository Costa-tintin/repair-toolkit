# repair-toolkit
Windows batch repair tool for IT technicians- runs system checks, network resets ,disk health scans and saves a timestamped report to the desktop automatically.
# repair-toolkit
A Windows batch repair tool for IT technicians. Run it on any Windows computeras Administrator — it performs 10 diagnostic and repair checks automaticallyand saves a full timestamped report to the Desktop.
---
## What It Does
| Step | Action | Tool Used ||---|---|---|| 1 | Collect full system information | `systeminfo` || 2 | Scan and repair system files | `sfc /scannow` || 3 | Repair Windows image | `DISM /RestoreHealth` || 4 | Full network diagnostics (IP, DNS, ping, traceroute, connections) | `ipconfig` `ping` `tracert` `netstat` || 5 | Reset network stack | `netsh winsock reset` `netsh int ip reset` || 6 | Check disk health | `chkdsk` `diskpart` || 7 | List startup programs | `wmic startup` || 8 | List all running processes | `tasklist` || 9 | Pull recent System and Application error events | `wevtutil` || 10 | List all installed software with version and install date | `wmic product` |
---
## Output
Every run saves a plain text report to the Desktop named:
