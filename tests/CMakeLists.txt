# QuickTest 测试目标。扫描本目录下 tst_*.qml。
# 链接静态 QML 模块(shadcn_ui + plugin、LucideIcons + plugin)以便 QML 侧 import。
find_package(Qt6 REQUIRED COMPONENTS QuickTest Qml Quick)

qt_add_executable(tst_shadcn tst_main.cpp)

target_link_libraries(tst_shadcn PRIVATE
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickTest
    shadcn_ui
    shadcn_uiplugin
    LucideIcons
    LucideIconsplugin
)

# QuickTest 从该目录加载 tst_*.qml。
target_compile_definitions(tst_shadcn PRIVATE
    QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

add_test(NAME tst_shadcn COMMAND tst_shadcn)
