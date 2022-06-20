@ECHO OFF
CLS
if "%1"=="" (
    set /P _id="Git issue id (nnnnn): "
    ) else (
    set _id=%1
)

Call :strlen _id _length
if %_length%==1 (
    set _gh_issue="GitHub_Issue_0000%_id%"
    set _gh_msg="GitHub issue 0000%_id%"
    ) else (
    if %_length%==2 (
        set _gh_issue="GitHub_Issue_000%_id%"
        set _gh_msg="GitHub issue 000%_id%"
        ) else (
        if %_length%==3 (
            set _gh_issue="GitHub_Issue_00%_id%"
            set _gh_msg="GitHub issue 00%_id%"
            ) else (
            if %_length%==4 (
                set _gh_issue="GitHub_Issue_0%_id%"
                set _gh_msg="GitHub issue 0%_id%"
                ) else (
                set _gh_issue="GitHub_Issue_%_id%"
                set _gh_msg="GitHub issue %_id%"
            )
        )
    )
)

ECHO Push Git branch
ECHO Branch name: %_gh_issue%
ECHO '
set /P _br="Press <ENTER> or <Ctrl-C>"

if "%_gh_issue%" neq "" (
    git checkout %_gh_issue%
    git push origin
    ) else (
    echo "Supply the git tag in semantic version format (n.n.n)."
)

git status
goto:eof

:strlen  StrVar  [RtnVar]
    setlocal EnableDelayedExpansion
    set "s=#!%~1!"
    set "len=0"
    for %%N in (8 4 2 1) do (
        if "!s:~%%N,1!" neq "" (
            set /a "len+=%%N"
            set "s=!s:~%%N!"
        )
    )
endlocal&if "%~2" neq "" (set %~2=%len%) else echo %len%
exit /b
