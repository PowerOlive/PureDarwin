add_executable(availability.pl IMPORTED GLOBAL)
set_property(TARGET availability.pl PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/availability.pl)

add_library(AvailabilityHeaders INTERFACE)
target_include_directories(AvailabilityHeaders INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/include/dyld/VersionMap.h
        ${CMAKE_CURRENT_BINARY_DIR}/include/dyld/for_dyld_priv.inc
    COMMAND ${CMAKE_COMMAND} -D SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR} -D HEADER_DIR=${CMAKE_CURRENT_BINARY_DIR}/include -P ${CMAKE_CURRENT_SOURCE_DIR}/build_headers.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Creating VersionMap.h and for_dyld_priv.inc" VERBATIM
)

add_darwin_object_library(dyld_availability_headers)
target_include_directories(dyld_availability_headers INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include)
target_sources(dyld_availability_headers PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/include/dyld/VersionMap.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/dyld/for_dyld_priv.inc
)

install(FILES include/Availability.h DESTINATION usr/include COMPONENT DeveloperTools)
install(FILES include/AvailabilityInternal.h DESTINATION usr/include COMPONENT DeveloperTools)
install(FILES include/AvailabilityMacros.h DESTINATION usr/include COMPONENT DeveloperTools)
install(FILES include/AvailabilityVersions.h DESTINATION usr/include COMPONENT DeveloperTools)
install(FILES include/ConditionalMacros.h DESTINATION usr/include COMPONENT DeveloperTools)
install(FILES include/TargetConditionals.h DESTINATION usr/include COMPONENT DeveloperTools)

install(DIRECTORY DESTINATION System/Library/Frameworks/Kernel.framework/Versions/A/Headers COMPONENT DeveloperTools)
install_symlink(
    /System/Library/Frameworks/Kernel.framework/Versions/A/Headers/AvailabilityVersions.h
    ../../../../../../../usr/include/AvailabilityVersions.h
    COMPONENT DeveloperTools
)
