# Build rules to create a GCC build executable
#
# Required variables
# - TARGET_NAME - Output file name
#
# Optional variables
# - LIBRARIES_DEBUG - Space separated list of all debug *.bc files that will be compiled
# - LIBRARIES_SHIP - Space separated list of all ship *.bc files that will be compiled
# - LIBRARIES_FLAGS_DEBUG - Space separated list of all debug -I and -L flags to pass to the compiler
# - LIBRARIES_FLAGS_SHIP - Space separated list of all ship -I and -L flags to pass to the compiler

# Inputs
CPP_FILES = $(call rwildcard,src/,*.cpp) 
HEADER_FILES = $(call rwildcard,src/,*.h) 
# Intermediary outputs
OBJ_FILES_DEBUG = $(patsubst %.cpp,debug_obj/%.o, $(CPP_FILES))
OBJ_FILES_SHIP = $(patsubst %.cpp,ship_obj/%.o, $(CPP_FILES))
# Outputs
TARGET_NAME_DEBUG = debug/$(TARGET_NAME)
TARGET_NAME_SHIP = ship/$(TARGET_NAME)
# Headers
HEADER_FILES_NO_SRC = $(patsubst src/%,%, $(HEADER_FILES))
HEADER_FILES_DEBUG = $(patsubst %.h,debug/headers/%.h, $(HEADER_FILES_NO_SRC))
HEADER_FILES_SHIP = $(patsubst %.h,ship/headers/%.h, $(HEADER_FILES_NO_SRC))

all: debug ship
debug: debug_gcc debug_headers
ship: ship_gcc ship_headers
debug_gcc: $(TARGET_NAME_DEBUG)
ship_gcc: $(TARGET_NAME_SHIP)
debug_headers: $(HEADER_FILES_DEBUG)
ship_headers: $(HEADER_FILES_SHIP)

$(TARGET_NAME_DEBUG): $(OBJ_FILES_DEBUG) $(LIBRARIES_DEBUG)
	$(call MakeDir,$(dir $@))
	g++ $(call FixPath,$(OBJ_FILES_DEBUG)) -o $(call FixPath,$@) $(LIBRARIES_FLAGS_DEBUG) $(GPP_FLAGS_DEBUG)

$(TARGET_NAME_SHIP): $(OBJ_FILES_SHIP) $(LIBRARIES_SHIP)
	$(call MakeDir,$(dir $@))
	g++ $(call FixPath,$(OBJ_FILES_SHIP)) -o $(call FixPath,$@) $(LIBRARIES_FLAGS_SHIP) $(GPP_FLAGS_SHIP)

debug_obj/%.o: %.cpp
	$(call MakeDir,$(dir $@))
	g++ -c $(call FixPath,$^) -o $(call FixPath,$@) $(LIBRARIES_FLAGS_DEBUG) $(GPP_FLAGS_DEBUG)

ship_obj/%.o: %.cpp
	$(call MakeDir,$(dir $@))
	g++ -c $(call FixPath,$^) -o $(call FixPath,$@) $(LIBRARIES_FLAGS_SHIP) $(GPP_FLAGS_SHIP)

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