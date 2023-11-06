start %SystemRoot%\explorer.exe /e, D:\GoogleDrive\Download
TIMEOUT /T 1
start %SystemRoot%\explorer.exe /e, D:\Dropbox\Projects
TIMEOUT /T 1
start %SystemRoot%\explorer.exe /e, D:\Dropbox\Projects
TIMEOUT /T 1
start powershell -noexit -command "cd 'D:\GoogleDrive\Projects'"
TIMEOUT /T 1
start powershell -noexit -command "cd 'D:\GoogleDrive\Projects'"
exit
