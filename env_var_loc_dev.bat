@ECHO Initialize local development environment variables
IF /I "%2"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
ECHO %_debug%
if %1=="" (
    SET MYSQL_TCP_PORT=3006
) else if %1==rte-db (
    SET MYSQL_TCP_PORT=50001
) else if %1==SQLAlchemyExample (
    SET MYSQL_TCP_PORT=50002
) else if %1==FastAPIExample (
    SET MYSQL_TCP_PORT=50002
) else if %1==rte-api (
    SET MYSQL_TCP_PORT=50003
)
