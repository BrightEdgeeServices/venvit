REM CLS
@ECHO OFF
@ECHO **************************
@ECHO * %date% %time% *
@ECHO **************************
IF /I "%2"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
IF %1=="" GOTO :AppHelp

@ECHO %_debug%
ECHO Push current branch to GitHub
ECHO '
::gitit adda
git add -A
rstcheck README.rst
pre-commit run --all-files
TIMEOUT /T 1
git add -A
pytest tests
::gitit commitcust -m %1
git commit -m %1
::gitit pushall
git push
GOTO :Exit

:AppHelp
@ECHO usage: push message debug
@ECHO where
@ECHO  - message: Description of the changes
@ECHO  - debug:   ON or OFF
@ECHO eg. push "Updated foo.bat"
ECHO '
GOTO :Exit

:Exit
EXIT /B 0
