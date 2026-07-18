qt_add_executable(shadcn_gallery main.cpp)

qt_add_qml_module(shadcn_gallery
    URI Gallery
    VERSION 1.0
    QML_FILES
        Gallery.qml
)

# STATIC 模块的 backing lib + plugin 均可链接;LucideIcons 供 gallery 直接/间接用。
target_link_libraries(shadcn_gallery PRIVATE
    Qt6::Quick
    shadcn_ui
    shadcn_uiplugin
    LucideIcons
    LucideIconsplugin
)
