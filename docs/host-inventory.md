# Host Inventory

| Item | Value | Command |
|------|-------|---------|
| CPU | 13th Gen Intel Core i5-13420H | `lscpu \| grep "Model name"` |
| CPU cores | 12 | `nproc` |
| RAM (total) | 7.6 GiB | `free -h` |
| RAM (available) | 7.1 GiB | `free -h` |
| Swap | 2.0 GiB | `free -h` |
| Disk (WSL view) | 954 GB free | `df -h ~` |
| Kernel | 6.6.87.2-microsoft-standard-WSL2 | `uname -r` |
| OS | Ubuntu 24.04.5 LTS | `grep PRETTY /etc/os-release` |

## Notes
- Runs on WSL2: Linux gets a share of the host RAM, not all of it.
- The WSL disk is a virtual file that grows on demand. The real limit is free space on the Windows drive (~26 GB).
- No GPU is used. Models run on CPU only, so small models (under 2 GB) are the target.
