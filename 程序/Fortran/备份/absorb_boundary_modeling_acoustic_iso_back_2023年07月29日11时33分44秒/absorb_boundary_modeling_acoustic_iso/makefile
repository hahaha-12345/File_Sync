<<<<<<< HEAD
#makefile for C/C++/Fortran

divider = "--------------------------------------------------------------------------------"

BackDir  = /mnt/hgfs/D/同步空间/程序/博士后程序/Fortran/备份
BinDir   = ./bin
IncDir   = ./inc
LogDir   = ./log
ObjDir   = ./obj
ParDir   = ./par
SrcDir   = ./src
ToolsDir = ./tools

Date=$(shell date "+%Y年%m月%d日%H时%M分%S秒")

#--------------------------------------#

Projname   = absorb_boundary_modeling_acoustic_iso

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
F90Src = $(wildcard $(SrcDir)/*.f90)
F77Src = $(wildcard $(SrcDir)/*.f)

CObj0   = $(patsubst %.c,%.o,${CSrc})
CppObj0 = $(patsubst %.cpp,%.o,${CppSrc})
F90Obj0 = $(patsubst %.f90,%.o,${F90Src})
F77Obj0 = $(patsubst %.f,%.o,${F77Src})

CObj00   = $(notdir $(CObj0))
CppObj00 = $(notdir $(CppObj0))
F90Obj00 = $(notdir $(F90Obj0))
F77Obj00 = $(notdir $(F77Obj0))

CObj   = $(addprefix $(ObjDir)/,$(CObj00))
CppObj = $(addprefix $(ObjDir)/,$(CppObj00))
F90Obj = $(addprefix $(ObjDir)/,$(F90Obj00))
F77Obj = $(addprefix $(ObjDir)/,$(F77Obj00))

OBJ    = $(CObj) $(CppObj) $(F90Obj) $(F77Obj)
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
	@echo '			Linking ---> ' $(EXE)
	@echo $(divider)
	$(LINKER) $^ -o $(EXE)  $(LINKLIBS) $(LINKER_FLAG) -fopenmp

$(ObjDir):
	mkdir -p $(ObjDir)

$(CppObj):$(ObjDir)/%.o:%.cpp
	@echo $(divider)
	@echo '			Making '$<'  --> *.o'
	@echo $(divider)
	$(CPP_CMPL) -c  -I$(IncDir) -I./inc $< -o $@ $(CPP_CMPL_FLAG) -fopenmp

$(CObj):$(ObjDir)/%.o:%.c
	@echo $(divider)
	@echo '			Making '$<'  --> *.o'
	@echo $(divider)
	$(C_CMPL)   -c  -I$(IncDir) -I./inc  $< -o $@ $(C_CMPL_FLAG)

$(F90Obj):$(ObjDir)/%.o:$(SrcDir)/%.f90
	@echo $(divider)
	@echo '			Making '$<'  --> '$@
	@echo $(divider)
	$(F90_CMPL)  -c  $< -o $@

$(F77Obj):$(ObjDir)/%.o:%.f
	@echo $(divider)
	@echo '			Making '$<'  --> *.o'
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
	@touch $(EXE)
	@touch $(OBJ)
	rm  $(EXE) $(OBJ)
	@pwd; echo $(Date)

run:
	time  $(RUN)  -machinefile  $(ToolsDir)/nodefile -np 1 $(EXE)  </dev/null>$(LogDir)/log  2>$(LogDir)/err  &

kill:
	./$(ToolsDir)/ido.sh  ./$(ToolsDir)/nodefile 'killall  -9  $(notdir $(exe))'
=======
#makefile for C/C++/Fortran

divider = "--------------------------------------------------------------------------------"

BackDir  = /mnt/hgfs/D/同步空间/程序/博士后程序/Fortran/备份
BinDir   = ./bin
IncDir   = ./inc
LogDir   = ./log
ObjDir   = ./obj
ParDir   = ./par
SrcDir   = ./src
ToolsDir = ./tools

Date=$(shell date "+%Y年%m月%d日%H时%M分%S秒")

#--------------------------------------#

Projname   = absorb_boundary_modeling_acoustic_iso

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
F90Src = $(wildcard $(SrcDir)/*.f90)
F77Src = $(wildcard $(SrcDir)/*.f)

CObj0   = $(patsubst %.c,%.o,${CSrc})
CppObj0 = $(patsubst %.cpp,%.o,${CppSrc})
F90Obj0 = $(patsubst %.f90,%.o,${F90Src})
F77Obj0 = $(patsubst %.f,%.o,${F77Src})

CObj00   = $(notdir $(CObj0))
CppObj00 = $(notdir $(CppObj0))
F90Obj00 = $(notdir $(F90Obj0))
F77Obj00 = $(notdir $(F77Obj0))

CObj   = $(addprefix $(ObjDir)/,$(CObj00))
CppObj = $(addprefix $(ObjDir)/,$(CppObj00))
F90Obj = $(addprefix $(ObjDir)/,$(F90Obj00))
F77Obj = $(addprefix $(ObjDir)/,$(F77Obj00))

OBJ    = $(CObj) $(CppObj) $(F90Obj) $(F77Obj)
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
	@echo '			Linking ---> ' $(EXE)
	@echo $(divider)
	$(LINKER) $^ -o $(EXE)  $(LINKLIBS) $(LINKER_FLAG) -fopenmp

$(ObjDir):
	mkdir -p $(ObjDir)

$(CppObj):$(ObjDir)/%.o:%.cpp
	@echo $(divider)
	@echo '			Making '$<'  --> *.o'
	@echo $(divider)
	$(CPP_CMPL) -c  -I$(IncDir) -I./inc $< -o $@ $(CPP_CMPL_FLAG) -fopenmp

$(CObj):$(ObjDir)/%.o:%.c
	@echo $(divider)
	@echo '			Making '$<'  --> *.o'
	@echo $(divider)
	$(C_CMPL)   -c  -I$(IncDir) -I./inc  $< -o $@ $(C_CMPL_FLAG)

$(F90Obj):$(ObjDir)/%.o:$(SrcDir)/%.f90
	@echo $(divider)
	@echo '			Making '$<'  --> '$@
	@echo $(divider)
	$(F90_CMPL)  -c  $< -o $@

$(F77Obj):$(ObjDir)/%.o:%.f
	@echo $(divider)
	@echo '			Making '$<'  --> *.o'
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
	@touch $(EXE)
	@touch $(OBJ)
	rm  $(EXE) $(OBJ)
	@pwd; echo $(Date)

run:
	time  $(RUN)  -machinefile  $(ToolsDir)/nodefile -np 1 $(EXE)  </dev/null>$(LogDir)/log  2>$(LogDir)/err  &

kill:
	./$(ToolsDir)/ido.sh  ./$(ToolsDir)/nodefile 'killall  -9  $(notdir $(exe))'
>>>>>>> 2b27bf6 (百度网盘Windows10)
