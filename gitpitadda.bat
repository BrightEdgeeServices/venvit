@ECHO OFF
CLS
if "%1"=="" (
    set /P _jira_id="JIRA ticket #: "
    ) else (
    set _jira_id=%1
)

ECHO Add files and Pre-Commit
ECHO '

if "%_jira_id%" neq "" (
    git checkout  %_jira_id%
    git add -A
    REM pre-commit autoupdate
    pre-commit
    git add -A
    pre-commit
    ) else (
    @echo "Supply the JIRA #"
)

git status
exit /b
