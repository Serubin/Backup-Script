# Online.net backup script

Script set is designed to be run with a single C14 archive. The script creates a new archive every week. 

Currently designed to be run as follows
open_archive.sh         week day: 1 time: 00:01 
backup.sh               hours: 2, 8, 14, 20
close_archive.sh        week day: 7 time: 23:10 (allow for archive time before re-open)


```cron
  1 0          *   *   1     /bin/bash /backup/open_archive.sh > /dev/null
  1 23         *   *   7     /bin/bash /backup/close_archive.sh > /dev/null
  0 2,8,14,22  *   *   *     /bin/bash /backup/backup.sh > /dev/null
```

