echo off
rem     This batch file MAKECOM.BAT is used in the form
rem         C>MAKECOM myfile
rem     and will use the Macro Assembler, Linker, and
rem     EXE2BIN utility to create an executable COM file.
rem
masm %1; >nul
if errorlevel 1 goto asmfail
link %1; >nul
if errorlevel 1 goto linkfail
if exist %1.com del %1.com
exe2bin %1.exe %1.com
if not exist %1.com goto comfail
echo *
echo * Assembly an Link successful, COM file created.
echo *
goto exit

:asmfail
echo *
echo * Error detected during Assembly, no files created.
echo *
goto exit

:linkfail
echo *
echo * Errors detected during LINK process, no files created.
echo *
goto exit

:comfail
echo *
echo * Can't convert EXE to COM file, no files created.
echo *

:exit
if exist %1.obj del %1.obj
if exist %1.exe del %1.exe
echo on