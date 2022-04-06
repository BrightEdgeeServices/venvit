@ECHO OFF
CLS
ECHO Push branch to Git
if "%1"=="" (
    set /P _id="Experian ticket #: "
    ) else (
    set _id=%1
    )

ECHO Push to Experian Git
ECHO Tag: %_id%
ECHO '
set /P _br="Press <ENTER> or <Ctrl-C>"

if "%_id%" neq "" (
    git push
    ) else (
    echo "Supply the ticket #."
)
