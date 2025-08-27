
# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.18.1)

# Declares and names the project.

project("np_platform_uploader")

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.

# configure import libs
set(exiv2_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../np_exiv2_lib/android/src/main/jniLibs)
set(exiv2_INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../dependency/exiv2/headers)

add_library( exiv2 SHARED IMPORTED )
set_target_properties( exiv2 PROPERTIES IMPORTED_LOCATION
    ${exiv2_DIR}/${ANDROID_ABI}/libexiv2.so )

add_library( # Sets the name of the library.
             np_platform_uploader

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             converter.cpp
             copy_metadata.cpp
             )
set_target_properties( np_platform_uploader PROPERTIES COMPILE_OPTIONS -fopenmp )

# Searches for a specified prebuilt library and stores the path as a
# variable. Because CMake includes system libraries in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library( # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log )

find_library( android-lib android )

target_include_directories( np_platform_uploader PRIVATE
                            ${exiv2_INC_DIR} )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries( # Specifies the target library.
                       np_platform_uploader

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib}
                       ${android-lib}
                       jnigraphics
                       exiv2
                       -fopenmp -static-openmp )
