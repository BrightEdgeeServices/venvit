@ECHO OFF
CLS
if "%1"=="" (
    set /P _id="Experian ticket #: "
    ) else (
    set _id=%1
)

ECHO Commit Git branch
ECHO Experian ticket #: %_id%
ECHO '
set /P _br="Press <ENTER> or <Ctrl-C>"

if "%_id%" neq "" (
    git commit -m %_id%
    ) else (
    echo "Supply the experian ticket #
)
git status
exit /b
