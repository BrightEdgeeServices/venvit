@ECHO OFF
CLS
if "%1"=="" (
    set /P _commit_msg="Commit message: "
    ) else (
    set _commit_msg=%1
)

ECHO Commit Branch
ECHO Commit message:   %_commit_msg%
ECHO '

if "%_commit_msg%" neq "" (
    git commit --allow-empty -m "%_commit_msg%"
    ) else (
    @echo "Supply the JIRA #"
)

git status
exit /b
