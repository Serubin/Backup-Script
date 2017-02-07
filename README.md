# Online.net backup script

Script set is designed to be run with a a single C14 archive. The script creates a new archive every week. 

Currently designed to be run as follows
open_archive.sh         week day: 1 time: 00:01 
backup.sh               hours: 4, 10, 16, 22
close_archive.sh        week day: 7 time: 23:10 (allow for archive time before re-open)

