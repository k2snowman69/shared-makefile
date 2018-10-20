# Shared constants that facilitate the building of multiple C++ projects

# g++ flags
GPP_FLAGS_DEBUG = -std=c++11 -O0 -g3
GPP_FLAGS_SHIP = -std=c++11 -O3
# emcc flags
EMCC_FLAGS_DEBUG = -std=c++11 -O0 -g4 -s NO_EXIT_RUNTIME=1 -s EXCEPTION_DEBUG=1 -s SAFE_HEAP=1
EMCC_FLAGS_SHIP = -std=c++11 -Oz -s NO_EXIT_RUNTIME=1