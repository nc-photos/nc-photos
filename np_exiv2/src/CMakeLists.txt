# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(np_exiv2_library VERSION 0.0.1 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 20)

add_library(exiv2 SHARED IMPORTED)
set_target_properties(
  exiv2
  PROPERTIES IMPORTED_LOCATION
  "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/exiv2/lib/${ANDROID_ABI}/libexiv2.so"
)

if (ANDROID)
  find_library(log-lib log)
  find_library(android-lib android)
endif()

add_library(np_exiv2 SHARED
  "np_exiv2.cpp"
  "reader.cpp"
)

add_compile_options(
  -Wall
)

set_target_properties(np_exiv2 PROPERTIES
  PUBLIC_HEADER np_exiv2.h
  OUTPUT_NAME "np_exiv2"
)

target_include_directories(
  np_exiv2
  PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/exiv2/include"
)
target_link_libraries(
  np_exiv2
  PRIVATE
  ${log-lib}
  ${android-lib}
  exiv2
)
target_compile_definitions(np_exiv2 PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(np_exiv2 PRIVATE "-Wl,-z,max-page-size=16384")
endif()
