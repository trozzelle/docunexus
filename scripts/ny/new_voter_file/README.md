# etl
Note the name of the latest file at https://console.cloud.google.com/storage/browser/nys_voter_file (i.e.AllNYSVoters_20210503.txt)

Log into terminal as root. Go to the repo root (/var/www/prd.docunexus.net/ or /var/www/dev.docunexus.net/ ...)

Run the download script, passing in the filename. Should take less than 5 minutes:
```bash
scripts/ny/new_voter_file/download.sh AllNYSVoters_20210503.txt
```

Review the log to make sure the file has a line count of around 20 million and that the file columns and character encoding match the load script

Run the script to load the file into a temporary table. Should take at least 70 minutes:
```bash
scripts/ny/new_voter_file/load.sh
```

Review the log for errors and inspect the counts at the end.

Run script to dedup the temporary table. Should take at least 50 minutes:
```bash
scripts/ny/new_voter_file/dedup.sh
```

Review the log.


If the following processes get cut off you can simply restart them and they should pick up where they left off. Each process may need to run multiple times in order to get through the entire queue of new voter records. When you review the log, run again if the end of the log DOES NOT show: 

```
STATUS:
COMPLETE!
```

Process may also run out of time.  When you review the log, run again if the end of the log DOES show: 

```
RAN OUT OF TIME
```

Run the process to update voter_data from the temporary table. Should take at least ??? hours:

```bash
scripts/ny/new_voter_file/data.sh
```

Process match files by match type:

* history2 - adds to dcnxs_ny.voter_history from import_ny.voter
* history - adds to dcnxs_ny.voter_history from dcnxs_ny.voter_data
* email - adds/updates dcnxs_ny.voter_email from dcnxs_ny.voter_data
* full_name - adds/updates dcnxs_ny.voter_full_name from dcnxs_ny.voter_data
* first_name - adds/updates dcnxs_ny.voter_first_name from dcnxs_ny.voter_data
* last_name - adds/updates dcnxs_ny.voter_last_name from dcnxs_ny.voter_data
* phone - adds/updates dcnxs_ny.voter_phone from dcnxs_ny.voter_data
* zip5 - adds/updates dcnxs_ny.voter_zip5 from dcnxs_ny.voter_data
* mailing_address - adds/updates dcnxs_ny.voter_mailing_address from dcnxs_ny.voter_data
* previous_address - adds/updates dcnxs_ny.voter_previous_address from dcnxs_ny.voter_data
* residence_address - adds/updates dcnxs_ny.voter_residence_address from dcnxs_ny.voter_data
* last_first_name (TODO)

Reset process_list.  For each match type, the command looks like this:

```bash
scripts/ny/new_voter_file/reset_process_list.sh history
```

Run the processes to refresh matching files. For each match type, the command looks like this:

```bash
scripts/ny/new_voter_file/refresh.sh history
```


Run the processes to refresh elections:

```bash
scripts/ny/new_voter_file/refresh.sh elections
```


