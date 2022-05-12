@ECHO ON

set _batch_dir=d:\dropbox\batch
@REM W5195935
if "%COMPUTERNAME%"=="W5202690" (
	set _batch_dir=d:\batch
)
cd %_batch_dir%
