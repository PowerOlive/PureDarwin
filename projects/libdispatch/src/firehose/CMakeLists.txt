add_darwin_static_library(libfirehose_kernel)
target_sources(libfirehose_kernel PRIVATE
    firehose_buffer.c
)

target_include_directories(libfirehose_kernel PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../..)
target_include_directories(libfirehose_kernel PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../../libpthread/include)
target_compile_definitions(libfirehose_kernel PRIVATE
    KERNEL=1 DISPATCH_USE_DTRACE=0 OS_ATOMIC_CONFIG_MEMORY_ORDER_DEPENDENCY=1
    OS_ATOMIC_CONFIG_MEMORY_ORDER_DEPENDENCY=1 OS_ATOMIC_CONFIG_STARVATION_FREE_ONLY=0)
target_compile_options(libfirehose_kernel PRIVATE -mkernel -Wno-packed -Wno-error=implicit-function-declaration)
target_link_libraries(libfirehose_kernel PRIVATE AvailabilityHeaders xnu_private_headers)
target_link_libraries(libfirehose_kernel PRIVATE xnu_kernel_headers xnu_kernel_private_headers)
target_link_libraries(libfirehose_kernel PRIVATE libplatform_headers libplatform_private_headers)
