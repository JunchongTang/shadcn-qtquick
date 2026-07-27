# QuickTest target. Scans tst_*.qml in this directory.
# Links the static QML modules (shadcn_ui + plugin, LucideIcons + plugin) so QML can import them.
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

# QuickTest loads tst_*.qml from this directory.
target_compile_definitions(tst_shadcn PRIVATE
    QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

add_test(NAME tst_shadcn COMMAND tst_shadcn)
