@ECHO Initialize local development environment variables
IF /I "%1"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
ECHO %_debug%
SET MYSQL_TCP_PORT_RTE=50001
SET MYSQL_TCP_PORT_EXAMPLES=50002
SET MYSQL_TCP_PORT_TRANS=60001
REM SET VENV_PYTHON_BASE=c:\Python
REM SET VENV_BASE=d:\venv
IF /I "%1"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)

