# Build rules to create a javascript library using emscripten
#
# Required variables
# - TARGET_NAME - Output file name
#
# Optional variables
# - LIBRARIES_DEBUG - Space separated list of all debug *.bc files that will be compiled
# - LIBRARIES_SHIP - Space separated list of all ship *.bc files that will be compiled
# - LIBRARIES_FLAGS_DEBUG - Space separated list of all debug -I and -L flags to pass to the compiler
# - LIBRARIES_FLAGS_SHIP - Space separated list of all ship -I and -L flags to pass to the compiler

# Outputs
TARGET_NAME_ES6 = $(TARGET_NAME).es6.js
TARGET_NAME_ES6_DEBUG = $(call FixPath,debug/$(TARGET_NAME_ES6))
TARGET_NAME_ES6_SHIP = $(call FixPath,ship/$(TARGET_NAME_ES6))
TARGET_NAME_GCC = $(TARGET_NAME).js
TARGET_NAME_GCC_DEBUG = $(call FixPath,debug/$(TARGET_NAME_GCC))
TARGET_NAME_GCC_SHIP = $(call FixPath,ship/$(TARGET_NAME_GCC))
# emcc flags
EMCC_JS_WRAPPER = -s MODULARIZE=1 -s SINGLE_FILE=1 -s EXPORT_ES6=1

all: debug ship
debug: $(TARGET_NAME_GCC_DEBUG)
ship: $(TARGET_NAME_GCC_SHIP)


# Required because EXPORT_ES6 outputs ES6 specific code and most libraries export ES5
$(TARGET_NAME_GCC_DEBUG): $(NPM_SUCCESS) $(TARGET_NAME_ES6_DEBUG)
	npm run build-debug

# Required because EXPORT_ES6 outputs ES6 specific code and most libraries export ES5
$(TARGET_NAME_GCC_SHIP): $(NPM_SUCCESS) $(TARGET_NAME_ES6_SHIP)
	npm run build-ship

$(TARGET_NAME_ES6_DEBUG): $(LIBRARIES_DEBUG)
	$(call MakeDir,$(dir $@))
	emcc --bind $(LIBRARIES_DEBUG) -o $(TARGET_NAME_ES6_DEBUG) $(EMCC_FLAGS_DEBUG) $(EMCC_JS_WRAPPER)

$(TARGET_NAME_ES6_SHIP): $(LIBRARIES_SHIP)
	$(call MakeDir,$(dir $@))
	emcc --bind $(LIBRARIES_SHIP) -o $(TARGET_NAME_ES6_SHIP) $(EMCC_FLAGS_SHIP) $(EMCC_JS_WRAPPER)
