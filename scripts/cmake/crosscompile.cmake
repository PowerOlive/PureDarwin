function(add_darwin_executable name)
    cmake_parse_arguments(SL "NO_STANDARD_LIBRARIES" "MACOSX_VERSION_MIN" "" ${ARGN})

    add_executable(${name})
    add_dependencies(${name} darwin_ld)
    target_link_options(${name} PRIVATE -fuse-ld=$<TARGET_FILE:darwin_ld>)
    target_compile_options(${name} PRIVATE -target x86_64-apple-darwin20)
    target_compile_options(${name} PRIVATE -nostdlib -nostdinc)
    target_link_options(${name} PRIVATE -nostdlib)

    # TODO: Handle SL_NO_STANDARD_LIBRARIES here, once the libraries have been added to the build.

    if(SL_MACOSX_VERSION_MIN)
        target_compile_options(${name} PRIVATE -mmacosx-version-min=${SL_MACOSX_VERSION_MIN})
        target_link_options(${name} PRIVATE -mmacosx-version-min=${SL_MACOSX_VERSION_MIN})
    endif()
endfunction()

function(add_darwin_static_library name)
    add_library(${name} STATIC)
    add_dependencies(${name} darwin_libtool)

    string(SUBSTRING ${name} 0 3 name_prefix)
    if(name_prefix STREQUAL "lib")
        set_property(TARGET ${name} PROPERTY PREFIX "")
    endif()

    target_compile_options(${name} PRIVATE -target x86_64-apple-darwin20)
    target_compile_options(${name} PRIVATE -nostdlib -nostdinc)
endfunction()

function(add_darwin_shared_library name)
    cmake_parse_arguments(SL "MODULE" "MACOSX_VERSION_MIN;INSTALL_NAME_DIR" "RPATHS" ${ARGN})

    if(SL_MODULE)
        add_library(${name} MODULE)
    else()
        add_library(${name} SHARED)
    endif()

    add_dependencies(${name} darwin_ld)
    target_link_options(${name} PRIVATE -fuse-ld=$<TARGET_FILE:darwin_ld>)

    string(SUBSTRING ${name} 0 3 name_prefix)
    if(name_prefix STREQUAL "lib")
        set_property(TARGET ${name} PROPERTY PREFIX "")
    endif()

    target_compile_options(${name} PRIVATE -target x86_64-apple-darwin20)
    target_compile_options(${name} PRIVATE -nostdlib -nostdinc)
    target_link_options(${name} PRIVATE -nostdlib)

    if(SL_MACOSX_VERSION_MIN)
        target_compile_options(${name} PRIVATE -mmacosx-version-min=${SL_MACOSX_VERSION_MIN})
        target_link_options(${name} PRIVATE -mmacosx-version-min=${SL_MACOSX_VERSION_MIN})
    endif()

    if(SL_INSTALL_NAME_DIR)
        target_link_options(${name} PRIVATE "LINKER:-install_name;${SL_INSTALL_NAME_DIR}/$<TARGET_FILE_NAME:${name}>")
    elseif(NOT SL_MODULE)
        message(WARNING "Shared library target ${name} should have INSTALL_NAME_DIR defined")
    endif()

    foreach(rpath IN LISTS SL_RPATHS)
        target_link_options(${name} PRIVATE "SHELL:-rpath ${rpath}")
    endforeach()
endfunction()

function(add_darwin_object_library name)
    add_library(${name} OBJECT)
    set_property(TARGET ${name} PROPERTY LINKER_LANGUAGE C)
    target_compile_options(${name} PRIVATE -target x86_64-apple-darwin20)
    target_compile_options(${name} PRIVATE -nostdlib -nostdinc)
endfunction()

set(CMAKE_SKIP_RPATH TRUE)
