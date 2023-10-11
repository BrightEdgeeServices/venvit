@ECHO Initialize local development environment variables
IF /I "%1"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
ECHO %_debug%

:: Set the ports
SET MYSQL_TCP_PORT=3006

:: Set the default userid's and passwords
SET LINUX_INSTALLER_PWD=N0tS0S3curePassw0rd
SET LINUX_INSTALLER_USERID=rtinstall
SET LINUX_ROOT_PWD=N0tS0S3curePassw0rd
SET MYSQL_HOST=localhost
SET MYSQL_PWD=N0tS0S3curePassw0rd
