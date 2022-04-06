@ECHO ON
CLS
if "%1"=="" (
cd     ) else (
    set _repo=%1
)

ECHO Clone Git Repository
ECHO Repo:  %_repo%
ECHO '
set /P br="Press <ENTER> or <Ctrl-C>"

if  "%_repo%" neq "" (
    git clone git@git.compuscan.co.za:CDS/%_repo%.git
    ) else (
    @echo "Supply the git repo name
)

exit /b
