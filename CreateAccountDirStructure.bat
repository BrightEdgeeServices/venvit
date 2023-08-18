@ECHO ON
IF /I "%4"=="ON" (
    set _debug=ON
    ) ELSE (
    set _debug=OFF
)
IF %1=="" GOTO :AppHelp
IF %2=="" GOTO :AppHelp
IF %3=="" GOTO :AppHelp

@ECHO %_debug%
ECHO Create an accounting directory structure for a financial year
ECHO '

md %1\%2\%3\"Backup\Archive"
md %1\%2\%3\"Books\Archive"
md %1\%2\%3\"Budget\Archive"
md %1\%2\%3\"Final Books\Archive"
md %1\%2\%3\"Final Books\Books\Archive"
md %1\%2\%3\"Final Books\Recons\Archive"
md %1\%2\%3\"Final Books\Reports\Archive"
md %1\%2\%3\"Final Books\Source Code\Archive"
md %1\%2\%3\"Final Books\YE Docs\Archive"
md %1\%2\%3\"Inventory\Archive"
md %1\%2\%3\"Payslip\Archive"
md %1\%2\%3\"Bank Statements\Archive"
md %1\%2\%3\"Claims\Archive"
md %1\%2\%3\"Client Invoices\Archive"
md %1\%2\%3\"Client Statements\Archive"
md %1\%2\%3\"Credit Notes\Archive"
md %1\%2\%3\"EMP201\Archive"
md %1\%2\%3\"PAYE\Archive"
md %1\%2\%3\"Payments\Archive"
md %1\%2\%3\"Purchase Orders\Archive"
md %1\%2\%3\"Quotations\Archive"
md %1\%2\%3\"Receipts\Archive"
md %1\%2\%3\"Return and Debit\Archive"
md %1\%2\%3\"Supplier Invoices\Archive"
md %1\%2\%3\"Supplier Statements\Archive"
md %1\%2\%3\"VAT\Archive"
md %1\%2\%3\"Tax Statements\Archive"
md %1\%2\%3\"Recons\Archive"
GOTO :Exit

:AppHelp
@ECHO usage: CreateAccountDirStructure root_dir company_dir finacial_year_YYYY
@ECHO where
@ECHO  - root_dir:           Root dir where the compnay accounting folder resides
@ECHO  - company_dir:        Existing directrory for accouts of the company
@ECHO  - finacial_year_YYYY: Financial year for the accounts
@ECHO  - debug:              ON or OFF
ECHO '
@ECHO eg. CreateAccountDirStructure d:\accounts XyzCOmpany 2024
ECHO '
GOTO :Exit

:Exit
EXIT /B 0
