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
    ) else (
    if %_length%==2 (
        set _gh_issue="GitHub_Issue_000%_id%"
        ) else (
        if %_length%==3 (
            set _gh_issue="GitHub_Issue_00%_id%"
            ) else (
            if %_length%==4 (
                set _gh_issue="GitHub_Issue_0%_id%"
                ) else (
                set _gh_issue="GitHub_Issue_%_id%"
            )
        )
    )
)

ECHO Create existing new Git branch
ECHO GitHub issue id:   %_id%
ECHO GitHub issue name: %_gh_issue%
ECHO '
set /P br="Press <ENTER> or <Ctrl-C>"

if "%_id%" neq "" (
    git checkout master
    git pull
    git checkout %_gh_issue%
    ) else (
    @echo "Supply the git 'issue' number as NNNNN"
)

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
