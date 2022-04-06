@ECHO OFF
CLS
if "%1"=="" (
cd     ) else (
    set _id=%1
)

ECHO Add to git branch
ECHO Experian branch:  %_id%
ECHO Add file:         %2
ECHO '
set /P br="Press <ENTER> or <Ctrl-C>"

if  "%_id%" neq "" (
    git checkout  %_id%
    git add %2
    ) else (
    @echo "Supply the git 'issue' number as nnnnn"
)

exit /b
