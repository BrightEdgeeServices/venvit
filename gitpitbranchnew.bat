@ECHO OFF
CLS
if "%1"=="" (
    set /P _jira_id="JIRA ticket #: "
    ) else (
    set _jira_id=%1
)

ECHO Create new Git branch
ECHO JIRA ticket #:   %_jira_id%
ECHO '
set /P br="Press <ENTER> or <Ctrl-C>"

if "%_jira_id%" neq "" (
    git checkout development
    git pull
    git checkout -b %_jira_id%
    git push -u origin %_jira_id%
    ) else (
    @echo "Supply the JIRA #"
)

git status
exit /b
