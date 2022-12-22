@ECHO Initialize local development environment variables
IF /I "%1"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
ECHO %_debug%
SET MYSQL_TCP_PORT_RTE=50001
SET MYSQL_TCP_PORT_TRANS=60001
SET VENV_PYTHON_BASE=c:\Python
SET VENV_BASE=d:\venv
SET VENV_PROJECTS=d:\Dropbox\Projects
