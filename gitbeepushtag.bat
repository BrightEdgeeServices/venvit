@ECHO OFF
CLS
ECHO Create a tag and push to Git
set /P _tag="Tag name (n.n.n): "

ECHO Push Git branch
ECHO Tag: %_tag%
ECHO '
set /P _br="Press <ENTER> or <Ctrl-C>"

if "%_tag%" neq "" (
    git checkout master
    REM git pull
    git tag -a %_tag% -m "Version %_tag%"
    REM git tag -a %_tag%
    git push --tag
    ) else (
    echo "Supply the git tag in semantic version format (n.n.n)."
)
git status
