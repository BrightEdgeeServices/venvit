@ECHO OFF
CLS
ECHO Create a tag and push to Git
set /P _tag="Tag name (n.n.n): "

ECHO Push Tag
ECHO Tag: %_tag%
ECHO '

if "%_tag%" neq "" (
    git checkout master
    git tag -a %_tag% -m "Version %_tag%"
    git push --tag
    ) else (
    echo "Supply the git tag in semantic version format (n.n.n)."
)
git status
