asm %1 %1 nul nul
link %1 @autolink
erase %1.bak
erase %1.obj
exe2bin %1 %1.com
erase %1.exe