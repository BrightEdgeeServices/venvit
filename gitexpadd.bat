@ECHO OFF
CLS
if "%1"=="" (
cd     ) else (
    set _id=%1
)

ECHO Add to git branch
ECHO Experian branch:  %_id%
@REM ECHO Add file:         %2
ECHO '
set /P br="Press <ENTER> or <Ctrl-C>"

if  "%_id%" neq "" (
    @REM git checkout  %_id%
    git add -A
    ) else (
    @echo "Supply Experian ticket nr as new branch name."
)

git status
exit /b
