# CleanupFolder
Cleans up a Folder by moving the files older than N days to a temporary location. 
After N+M days the files are permanently deleted
It also sends an HTML report via email with the listo of files moved and deleted

## Getting Started
1. Download the files
2. In CleanUpFolder.ps1 set the variables according to your necessities
3. In Send-ToEmail.ps1 configure SMTP parameters in order to send the email report
4. Execute with powershell
5. Enjoy

### Schedule execution
To execute this script as a scheduled task:
1. Open TaskManager and select Create Basic task
2. Enter a Name and a Description (optional)
3. Choose the Trigger (ie. Weekly)
4. In Action choose "Start a Program"
5. In Program enter: Powershell.exe
6. In Arguments enter: -nologo -noprofile -noninteractive -ExecutionPolicy Bypass -File U:\Complete\Path\CleanUpFolder.ps1


## Author
Roberto Figueroa

## License
Unlicensed

## Acknowledgments
