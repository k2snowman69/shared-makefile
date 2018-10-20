# Useful methods or functions written for windows and unix for cross compatibility

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
ifeq ($(OS),Windows_NT)
	FixPath = $(subst /,\,$1)
	MakeDir = $(shell if not exist $(call FixPath,$(dir $1)) mkdir $(call FixPath,$(dir $1)))
	RemoveDir = if exist $1 rmdir /S /Q $1
	Make = mingw32-make
	CmdSeparator = &&
	CopyFile = xcopy $1 $2 /Q /Y /I
else
	FixPath = $1
	MakeDir = mkdir -p $1
	RemoveDir = if exist $1 rmdir /S /Q $1
	Make = make
	CmdSeparator = ;
	CopyFile = cp -f $1 $2
endif