project(minidebuginfo)

add_library(mylib mylib.cpp)
add_executable(myexe myexe.cpp)
target_link_libraries(myexe mylib)
