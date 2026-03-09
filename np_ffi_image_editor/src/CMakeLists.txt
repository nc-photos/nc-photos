# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(np_ffi_image_editor_library VERSION 0.0.1 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 20)

add_library(gpupixel SHARED IMPORTED)
set_target_properties(
  gpupixel
  PROPERTIES IMPORTED_LOCATION
  "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/gpupixel/lib/${ANDROID_ABI}/libgpupixel.so"
)

if (ANDROID)
  find_library(log-lib log)
  find_library(android-lib android)
endif()

add_library(np_ffi_image_editor SHARED
  "gpupixel_helper.cpp"
  "np_ffi_image_editor.cpp"
  "edit/black_point.cpp"
  "edit/brightness.cpp"
  "edit/contrast.cpp"
  "edit/crop.cpp"
  "edit/halftone.cpp"
  "edit/gpupixel_composite.cpp"
  "edit/orientation.cpp"
  "edit/pixelation.cpp"
  "edit/posterization.cpp"
  "edit/saturation.cpp"
  "edit/sketch.cpp"
  "edit/tint.cpp"
  "edit/toon.cpp"
  "edit/warmth.cpp"
  "edit/white_point.cpp"
)

add_compile_options(
  -Wall
)

set_target_properties(np_ffi_image_editor PROPERTIES
  PUBLIC_HEADER np_ffi_image_editor.h
  OUTPUT_NAME "np_ffi_image_editor"
)

target_include_directories(
  np_ffi_image_editor
  PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/gpupixel/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/json/include"
)
target_link_libraries(
  np_ffi_image_editor
  PRIVATE
  ${log-lib}
  ${android-lib}
  gpupixel
  EGL
  -fopenmp -static-openmp
)
target_compile_definitions(np_ffi_image_editor PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(np_ffi_image_editor PRIVATE "-Wl,-z,max-page-size=16384")
endif()
