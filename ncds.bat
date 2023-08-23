@ECHO ON
IF /I "%3"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
IF %1=="" GOTO :AppHelp
IF %2=="" GOTO :AppHelp

@ECHO %_debug%
ECHO Create a company directory structure
ECHO '

:RunProcedure
md %1\%2\"Contracts"
md %1\%2\"Correspondance"
md %1\%2\"Correspondance\Recieved"
md %1\%2\"Correspondance\Sent"
md %1\%2\"Logos"
md %1\%2\"Meetings"
md %1\%2\"Planning"
md %1\%2\"Pol & Proc"
md %1\%2\"Statutory Documents"
GOTO :Exit

:AppHelp
@ECHO New Company Directory Stucture (ncds)
@ECHO usage: ncds root_dir company_dir
@ECHO where
@ECHO  - root_dir:           Root dir where the company folder resides
@ECHO  - company_dir:        Name of the company.  THis will also be the folder name
@ECHO  - debug:              ON or OFF
ECHO '
@ECHO eg. ncds d:\GoogleDrive XyzCompany ON
ECHO '
GOTO :Exit

:Exit
EXIT /B 0
