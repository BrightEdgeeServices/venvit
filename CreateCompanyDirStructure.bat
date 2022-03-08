ECHO ON
CLS
REM Create the base structure for a company
REm %1 CompanyName       Company name

IF /I %1==/h GOTO Help:
IF /I %1==/? GOTO Help:
GOTO RunProcedure:

:Help
@ECHO Create company folder stuctture
@ECHO .                      
@ECHO Usage: CreateCompanyDirStructure CompanyName Drive
@ECHO .
@ECHO CompanyName       The company name used in the folder structure
ECHO  .
@ECHO Examples:
@ECHO Usage: CreateCompanyDirStructure
GOTO Exit:

:RunProcedure
md "%1\Development"
md "%1\Docs"
md "%1\Docs\Contracts"
md "%1\Docs\Financial"
md "%1\Docs\Financial\Forecasts"
md "%1\Docs\Financial\Payslips"
md "%1\Docs\Letters"
md "%1\Docs\Minutes"
md "%1\Docs\Planning"
md "%1\Docs\Presentation"
md "%1\Docs\Procedures"
md "%1\Docs\Proposals"
md "%1\Docs\Staff"
md "%1\Images"
md "%1\Projects"
md "%1\Templates"
md "%1\Templates\Docs"
md "%1\Templates\File Labels"
md "%1\Templates\Internal Forms"
md "%1\Templates\Logo"

:Exit