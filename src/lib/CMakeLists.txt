cmake_minimum_required(VERSION 3.14)
project(torch.clawed)

SET(CMAKE_POSITION_INDEPENDENT_CODE ON)
SET(CMAKE_LINK_WHAT_YOU_USE ON)
SET(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
SET(CMAKE_INSTALL_RPATH "$\{ORIGIN\}")

SET(LIBRARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/torch)

if (MSVC)
    add_compile_options(/O2)
    if (NOT ANDROID_ABI)
      add_compile_options(/arch:AVX)
    endif()
else()
    add_compile_options(-O2)
    if (NOT ANDROID_ABI)
      set(TARGET_TRIPLE x86_64-unknown-linux-gnu)
      add_compile_options(-mavx)
    else()
      set(TARGET_TRIPLE aarch64-linux-android)
      add_compile_options(-mfpu=neon)
    endif()
endif()

#
# MAIN
#
SET(PYTORCH_BIN_INSTALL_PREFIX "../../libtorch")

# The generated adapter refers to internal names from the Clang headers.
# We need to list the Clang include directories explicitly below,
# and also pass `-nostdinc++'.
SET(CMAKE_C_COMPILER clang)
SET(CMAKE_CXX_COMPILER clang++)

SET(TARGET torch.clawed)
SET(ADAPTER "adapter.${TARGET_TRIPLE}.cxx")

add_library(${TARGET} SHARED ${ADAPTER})

set_source_files_properties(${ADAPTER} PROPERTIES LANGUAGE CXX)

target_include_directories(${TARGET}
  PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/../"
         "${PYTORCH_BIN_INSTALL_PREFIX}/include/"
         "${PYTORCH_BIN_INSTALL_PREFIX}/include/torch/csrc/api/include/"
	 # FIXME: Locate LLVM dynamically
	 "/usr/local/llvm/include/x86_64-unknown-linux-gnu/c++/v1/"
	 "/usr/local/llvm/include/c++/v1/")

target_compile_options(${TARGET} PUBLIC -nostdinc++)

target_link_directories(${TARGET}
  PUBLIC "${PYTORCH_BIN_INSTALL_PREFIX}/lib/")


target_link_libraries(${TARGET} PUBLIC torch)
