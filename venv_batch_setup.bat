@ECHO ON
set _python_base_dir="c:\Program Files Python"
set _venv_base_dir=d:\venv
set _batch_dir=d:\dropbox\batch
set _projects_dir=d:\Dropbox\Projects
@REM W5195935
if "%COMPUTERNAME%"=="W5202690" (
	set _python_base_dir=c:\Python
	set _venv_base_dir=c:\venv
	set _batch_dir=d:\batch
	set _projects_dir=d:\Projects
)
cd %_batch_dir%
