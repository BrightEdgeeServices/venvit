@ECHO OFF
CLS
ECHO Create a tag and push to Git
if "%1"=="" (
    set /P _tag="Tag name (n.n.n): "
    ) else (
    set _tag=%1
    )

ECHO Push Git branch
ECHO Tag: %_tag%
ECHO '
set /P _br="Press <ENTER> or <Ctrl-C>"

if "%_tag%" neq "" (
    git checkout master
    git push origin master
    git tag -m "Version %_tag%" %_tag%
    git push --tag
    ) else (
    echo "Supply the git tag in semantic version format (n.n.n)."
)
