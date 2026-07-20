cmake_minimum_required(VERSION 3.22)
project(shadcn-qtquick VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(SHADCN_BUILD_EXAMPLES "Build the shadcn-qtquick gallery example" ON)
option(SHADCN_BUILD_TESTS "Build the shadcn-qtquick unit tests" ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Core Gui Qml Quick)
qt_standard_project_setup(REQUIRES 6.8)

# 依赖:Lucide 图标(vendored 子模块)。带守卫,便于消费方已提供 LucideIcons 时不重复添加。
if(NOT TARGET LucideIcons)
    set(LUCIDE_QTQUICK_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    add_subdirectory(third_party/lucide-qtquick)
endif()

add_subdirectory(src)

if(SHADCN_BUILD_EXAMPLES)
    add_subdirectory(examples/gallery)
endif()

if(SHADCN_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
