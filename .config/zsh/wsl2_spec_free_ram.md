# WSL2 Specific Note
If the VM goes rogue and decides not to free up memory, this command will free your memory after
about 20-30 seconds. [Details](https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643)

```bash
alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a &&
printf '\n%s\n' 'Ram, Cache & Swap cleared'\""
```
