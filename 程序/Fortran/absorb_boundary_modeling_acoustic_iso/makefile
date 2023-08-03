#makefile for C/C++/Fortran

divider = "--------------------------------------------------------------------------------"

BackDir  = /mnt/hgfs/D/同步空间/程序/博士后程序/Fortran/备份
BinDir   = ./bin
IncDir   = ./lib
LogDir   = ./log
ObjDir   = ./obj
ParDir   = ./par
SrcDir   = ./src
ToolsDir = ./tools

Date=$(shell date "+%Y年%m月%d日%H时%M分%S秒")

#--------------------------------------#

ParentDir = $(shell dirname "$(realpath $(lastword $(MAKEFILE_LIST)))")
Projname = $(notdir $(patsubst %/,%,$(ParentDir)))

#--------------------------------------#

#compiler

#CPP_CMPL_0 = icpc
CPP_CMPL_0 = mpicxx
CPP_CMPL = $(CPP_CMPL_0) -O3 -std=c++11
C_CMPL   = icc -O3
F90_CMPL   = mpif90 -f90=ifort -O3 -cpp
F77_CMPL   = mpif90 -f90=ifort -O3 -cpp
LINKER   = $(F90_CMPL)

RUN      = mpirun

C_CMPL_FLAG   = -Wno-unused-result
#CPP_CMPL_FLAG = -Wno-unused-result -fmax-errors=5
CPP_CMPL_FLAG = -fmax-errors=5 -DARMA_ALLOW_FAKE_GCC
F_CMPL_FLAG   =
LINKER_FLAG   =
LINKLIBS	  = -lm

#--------------------------------------#

CSrc   = $(wildcard $(SrcDir)/*.c)
CppSrc = $(wildcard $(SrcDir)/*.cpp)
module_F90Src = $(wildcard $(SrcDir)/*module*.f90)
module_F77Src = $(wildcard $(SrcDir)/*module*.f)
other_F90Src  = $(filter-out $(module_F90Src),$(wildcard $(SrcDir)/*.f90))
other_F77Src  = $(filter-out $(module_F77Src),$(wildcard $(SrcDir)/*.f))

CObj0   = $(patsubst %.c,%.o,${CSrc})
CppObj0 = $(patsubst %.cpp,%.o,${CppSrc})
module_F90Obj0 = $(patsubst %.f90,%.mod,${module_F90Src})
other_F90Obj0  = $(patsubst %.f90,%.o,${other_F90Src})
module_F77Obj0 = $(patsubst %.f,%.mod,${module_F77Src})
other_F77Obj0  = $(patsubst %.f,%.o,${other_F77Src})

CObj00   = $(notdir $(CObj0))
CppObj00 = $(notdir $(CppObj0))
module_F90Obj00 = $(notdir $(module_F90Obj0))
other_F90Obj00  = $(notdir $(other_F90Obj0))
module_F77Obj00 = $(notdir $(module_F77Obj0))
other_F77Obj00  = $(notdir $(other_F77Obj0))

CObj   = $(addprefix $(ObjDir)/,$(CObj00))
CppObj = $(addprefix $(ObjDir)/,$(CppObj00))
module_F90Obj = $(addprefix $(ObjDir)/,$(module_F90Obj00))
other_F90Obj  = $(addprefix $(ObjDir)/,$(other_F90Obj00))
module_F77Obj = $(addprefix $(ObjDir)/,$(module_F77Obj00))
other_F77Obj  = $(addprefix $(ObjDir)/,$(other_F77Obj00))

OBJ    = $(CObj) $(CppObj) $(module_F90Obj) $(other_F90Obj) $(module_F77Obj) $(other_F77Obj)
EXE    = $(BinDir)/$(Projname).e
BACK   = $(BackDir)/$(Projname)_back_$(Date).tgz
Back_Content = $(shell basename $(shell pwd))
tar_message = "--exclude=none"
#tar_message = "--exclude=*.sw? --exclude=*.log --exclude=*.[oe]"

#--------------------------------------#

all:
	mkdir -p $(LogDir) $(ObjDir)
	make -j 1 $(EXE)

$(EXE):$(OBJ)
	@echo $(divider)
	@echo '			Linking' $^ ' ---> ' $(EXE)
	@echo $(divider)
	$(LINKER) $^ -o $(EXE)  $(LINKLIBS) $(LINKER_FLAG) -fopenmp

$(ObjDir):
	mkdir -p $(ObjDir)

$(CppObj):$(ObjDir)/%.o:$(SrcDir)/%.cpp
	@echo $(divider)
	@echo '			Making ' $< '  --> ' $@
	@echo $(divider)
	$(CPP_CMPL) -c  -I$(IncDir) -I./lib $< -o $@ $(CPP_CMPL_FLAG) -fopenmp

$(CObj):$(ObjDir)/%.o:$(SrcDir)/%.c
	@echo $(divider)
	@echo '			Making ' $< '  --> ' $@
	@echo $(divider)
	$(C_CMPL)   -c  -I$(IncDir) -I./lib  $< -o $@ $(C_CMPL_FLAG)

$(module_F90Obj):$(ObjDir)/%.mod:$(SrcDir)/%.f90
	@echo $(divider)
	@echo '			Making ' $< '  --> ' $@
	@echo $(divider)
	$(F90_CMPL)  -c  $< -o $@

$(other_F90Obj):$(ObjDir)/%.o:$(SrcDir)/%.f90
	@echo $(divider)
	@echo '			Making ' $< '  --> ' $@
	@echo $(divider)
	$(F90_CMPL)  -c  $< -o $@

$(module_F77Obj):$(ObjDir)/%.mod:$(SrcDir)/%.f
	@echo $(divider)
	@echo '			Making ' $< '  --> ' $@
	@echo $(divider)
	$(F77_CMPL)  -c  $< -o $@

$(other_F77Obj):$(ObjDir)/%.o:$(SrcDir)/%.f
	@echo $(divider)
	@echo '			Making ' $< '  --> ' $@
	@echo $(divider)
	$(F77_CMPL)  -c  $< -o $@

#--------------------------------------#

.PHONY:back,clean,run,kill

backup:
	mkdir -p $(BackDir)
	tar $(tar_message)  -czvf  $(BACK)  ../$(Back_Content)
	ls -hl $(BACK)
b:backup

clean:
	rm  $(EXE)  $(OBJ)
	@pwd; echo $(Date)

run:
	time  $(RUN)  -machinefile  $(ToolsDir)/nodefile -np 1 $(EXE)  </dev/null>$(LogDir)/log  2>$(LogDir)/err  &

kill:
	ps -ef | grep $(notdir $(EXE)) | grep -v grep | cut -c 9-15 | xargs kill -9
