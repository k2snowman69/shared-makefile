# Build rules to create a GCC library
#
# Required variables
# - TARGET_NAME - Output file name
# Optional variables
# - LIBRARIES_DEBUG - Space separated list of all debug *.bc files that will be compiled
# - LIBRARIES_SHIP - Space separated list of all ship *.bc files that will be compiled
# - LIBRARIES_FLAGS_DEBUG - Space separated list of all debug -I and -L flags to pass to the compiler
# - LIBRARIES_FLAGS_SHIP - Space separated list of all ship -I and -L flags to pass to the compiler

#Outputs
TARGET_NAME_GCC = lib$(TARGET_NAME).a
TARGET_NAME_EMCC = $(TARGET_NAME).bc
TARGET_NAME_GCC_DEBUG = debug/$(TARGET_NAME_GCC)
TARGET_NAME_GCC_SHIP = ship/$(TARGET_NAME_GCC)
TARGET_NAME_EMCC_DEBUG = debug/$(TARGET_NAME_EMCC)
TARGET_NAME_EMCC_SHIP = ship/$(TARGET_NAME_EMCC)
# Inputs
CPP_FILES = $(call rwildcard,src/,*.cpp) 
HEADER_FILES = $(call rwildcard,src/,*.h) 
# Intermediary outputs
OBJ_FILES_DEBUG_GCC = $(patsubst %.cpp,debug_obj/gcc/%.o, $(CPP_FILES))
OBJ_FILES_SHIP_GCC = $(patsubst %.cpp,ship_obj/gcc/%.o, $(CPP_FILES))
OBJ_FILES_DEBUG_EMCC = $(patsubst %.cpp,debug_obj/emcc/%.o, $(CPP_FILES))
OBJ_FILES_SHIP_EMCC = $(patsubst %.cpp,ship_obj/emcc/%.o, $(CPP_FILES))
# Headers
HEADER_FILES_NO_SRC = $(patsubst src/%,%, $(HEADER_FILES))
HEADER_FILES_DEBUG = $(patsubst %.h,debug/headers/%.h, $(HEADER_FILES_NO_SRC))
HEADER_FILES_SHIP = $(patsubst %.h,ship/headers/%.h, $(HEADER_FILES_NO_SRC))

all: debug ship
debug: debug_gcc debug_emcc debug_headers
ship: ship_gcc ship_emcc ship_headers
debug_gcc: $(TARGET_NAME_GCC_DEBUG)
ship_gcc: $(TARGET_NAME_GCC_SHIP)
debug_emcc: $(TARGET_NAME_EMCC_DEBUG)
ship_emcc: $(TARGET_NAME_EMCC_SHIP)
debug_headers: $(HEADER_FILES_DEBUG)
ship_headers: $(HEADER_FILES_SHIP)

$(TARGET_NAME_GCC_DEBUG): $(OBJ_FILES_DEBUG_GCC)
	$(call MakeDir,$(dir $@))
	ar rcs $(call FixPath,$(TARGET_NAME_GCC_DEBUG)) $(call FixPath,$(OBJ_FILES_DEBUG_GCC))

$(TARGET_NAME_GCC_SHIP): $(OBJ_FILES_SHIP_GCC)
	$(call MakeDir,$(dir $@))
	ar rcs $(call FixPath,$(TARGET_NAME_GCC_SHIP)) $(call FixPath,$(OBJ_FILES_SHIP_GCC))

$(TARGET_NAME_EMCC_DEBUG): $(OBJ_FILES_DEBUG_EMCC)
	$(call MakeDir,$(dir $@))
	emcc $(call FixPath,$^) -o $(call FixPath,$@) $(EMCC_FLAGS_DEBUG) $(LIBRARIES_FLAGS_DEBUG)

$(TARGET_NAME_EMCC_SHIP): $(OBJ_FILES_SHIP_EMCC)
	$(call MakeDir,$(dir $@))
	emcc $(call FixPath,$^) -o $(call FixPath,$@) $(EMCC_FLAGS_SHIP) $(LIBRARIES_FLAGS_DEBUG)

debug_obj/gcc/%.o: %.cpp
	$(call MakeDir,$(dir $@))
	g++ -c $(call FixPath,$^) -o $(call FixPath,$@) $(GPP_FLAGS_DEBUG) $(LIBRARIES_FLAGS_DEBUG)

ship_obj/gcc/%.o: %.cpp
	$(call MakeDir,$(dir $@))
	g++ -c $(call FixPath,$^) -o $(call FixPath,$@) $(GPP_FLAGS_SHIP) $(LIBRARIES_FLAGS_DEBUG)

debug_obj/emcc/%.o: %.cpp
	$(call MakeDir,$(dir $@))
	emcc -c $(call FixPath,$^) -o $(call FixPath,$@) $(EMCC_FLAGS_DEBUG) $(LIBRARIES_FLAGS_DEBUG)

ship_obj/emcc/%.o: %.cpp
	$(call MakeDir,$(dir $@))
	emcc -c $(call FixPath,$^) -o $(call FixPath,$@) $(EMCC_FLAGS_SHIP) $(LIBRARIES_FLAGS_DEBUG)

debug/headers/%: src/%
	$(call MakeDir,$(dir $@))
	$(call CopyFile,$(call FixPath,$^),$(call FixPath,$(dir $@).))

ship/headers/%: src/%
	$(call MakeDir,$(dir $@))
	$(call CopyFile,$(call FixPath,$^),$(call FixPath,$(dir $@).))

.PHONY: clean
clean:
	$(call RemoveDir,debug)
	$(call RemoveDir,debug_obj)
	$(call RemoveDir,ship)
	$(call RemoveDir,ship_obj)