@ECHO ON
CLS
if "%1"=="" (
    set /P _id="Experian ticket #: "
    ) else (
    set _id=%1
)

ECHO Create new Git branch
ECHO Experian ticket #: %_id%
ECHO '
set /P br="Press <ENTER> or <Ctrl-C>"

if "%_id%" neq "" (
    git checkout develop
    git pull
    git checkout -b %_id% --track origin/%_id%
    ) else (
    @echo "Supply the git 'issue' number as NNNNN"
)
exit /b
