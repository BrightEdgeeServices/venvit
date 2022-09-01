@ECHO ON
CLS
if "%1"=="" (
    set /P _id="Git issue id (nnnnn): "
    ) else (
    set _id=%1
)

ECHO Checkout Existing Branch
ECHO GitHub issue id:   %_id%
ECHO '

if "%_id%" neq "" (
    git stash
    git checkout %_id%
    git stash pop
    ) else (
    @echo "Supply the git 'issue' number as NNNNN"
)

git status
