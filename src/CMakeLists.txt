# Shadcn 组件库(QML)—— STATIC qml 模块,消费方 add_subdirectory 后链接
# shadcn_ui + shadcn_uiplugin,QML 侧 import Shadcn(组件无前缀:Button/Input/…)。
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(shadcn_ui
    STATIC
    URI Shadcn
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Shadcn"
    QML_FILES
        Theme.qml
        Button.qml
        IconButton.qml
        Badge.qml
        Separator.qml
        Input.qml
        Textarea.qml
        Label.qml
        Checkbox.qml
        Select.qml
        Card.qml
        Tabs.qml
        TabButton.qml
        ScrollView.qml
        Tooltip.qml
        Menu.qml
        MenuItem.qml
        MenuSeparator.qml
        Dialog.qml
)

# 组件用 LucideIcon(import LucideIcons);MultiEffect 阴影用 QtQuick.Effects。
target_link_libraries(shadcn_ui PRIVATE Qt6::Quick LucideIcons)
