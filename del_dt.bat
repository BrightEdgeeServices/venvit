@ECHO OFF
@ECHO Remove desktop.ini from Git directory
del .git\refs\desktop.ini /S /Q /A:H
