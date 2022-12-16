@ECHO OFF
CLS
if "%1"=="" (
    set /P _jira_id="JIRA ticket #: "
    ) else (
    set _jira_id=%1
)

ECHO Push Branch
ECHO JIRA ticket #:   %_jira_id%
ECHO '

if "%_jira_id%" neq "" (
    git checkout %_jira_id%
    git push origin
    ) else (
    @echo "Supply the JIRA #"
)

git status
exit /b
