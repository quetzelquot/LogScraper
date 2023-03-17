# LogScraper
Bash script to automate searching through logs by not outputting removing similar (but slightly different) entries.

How it works:

The bash script will recursively grep through the chosen directory (e.g. `/var/log/`), then hash each line of text with the date and all numbers removed, and save the value to a rolling hash table. If the hash of the line in the log file already exists in the table, the line will be discarded. Otherwise, it will be saved to the output.
