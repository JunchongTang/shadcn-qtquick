import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 完整应用侧边栏:头部品牌 + 若干分组菜单(图标 + 文本)+ 页脚用户项,
// 右侧配一个简化的 inset 内容区,整体放进有边框圆角的容器中展示。
// 简化(见报告):可折叠图标条 / 移动端 sheet / SidebarTrigger / inset 圆角浮起等未实现。
Rectangle {
    id: shell
    width: 620
    height: 460
    radius: Theme.radiusLg
    color: Theme.background
    border.width: 1
    border.color: Theme.border
    clip: true

    property string current: "data-fetching"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==== 侧边栏 ====
        Sidebar {
            Layout.preferredWidth: 240
            Layout.fillHeight: true

            SidebarHeader {
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        radius: Theme.radiusMd
                        color: Theme.sidebarPrimary
                        LucideIcon {
                            anchors.centerIn: parent
                            name: "file-text"
                            size: 16
                            color: Theme.sidebarPrimaryForeground
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            Layout.fillWidth: true
                            text: "Documentation"
                            color: Theme.sidebarForeground
                            font.pixelSize: Theme.textSm
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.fillWidth: true
                            text: "v2.0.0"
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textXs
                            elide: Text.ElideRight
                        }
                    }
                    LucideIcon {
                        name: "chevrons-up-down"
                        size: 16
                        color: Theme.mutedForeground
                    }
                }
            }

            SidebarSeparator {}

            SidebarContent {
                SidebarGroup {
                    SidebarGroupLabel { text: "Getting Started" }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Installation"; iconName: "download"
                                active: shell.current === "installation"
                                onClicked: shell.current = "installation"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Project Structure"; iconName: "folder"
                                active: shell.current === "structure"
                                onClicked: shell.current = "structure"
                            }
                        }
                    }
                }

                SidebarGroup {
                    SidebarGroupLabel { text: "Build Your Application" }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Routing"; iconName: "layout"
                                active: shell.current === "routing"
                                onClicked: shell.current = "routing"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Data Fetching"; iconName: "code"
                                active: shell.current === "data-fetching"
                                onClicked: shell.current = "data-fetching"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Rendering"; iconName: "monitor"
                                active: shell.current === "rendering"
                                onClicked: shell.current = "rendering"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Caching"; iconName: "bookmark"
                                active: shell.current === "caching"
                                onClicked: shell.current = "caching"
                            }
                        }
                    }
                }

                SidebarGroup {
                    SidebarGroupLabel { text: "API Reference" }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "Components"; iconName: "file-code"
                                active: shell.current === "components"
                                onClicked: shell.current = "components"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "File Conventions"; iconName: "file"
                                active: shell.current === "conventions"
                                onClicked: shell.current = "conventions"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: "CLI"; iconName: "keyboard"
                                active: shell.current === "cli"
                                onClicked: shell.current = "cli"
                            }
                        }
                    }
                }
            }

            SidebarSeparator {}

            SidebarFooter {
                SidebarMenu {
                    SidebarMenuItem {
                        SidebarMenuButton {
                            text: "Settings"; iconName: "settings"
                            active: shell.current === "settings"
                            onClicked: shell.current = "settings"
                        }
                    }
                    SidebarMenuItem {
                        SidebarMenuButton {
                            text: "shadcn"; iconName: "user"
                        }
                    }
                }
            }
        }

        // ==== 简化 inset 内容区 ====
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Text {
                    text: "Data Fetching"
                    color: Theme.foreground
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Repeater {
                        model: 3
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 72
                            radius: Theme.radiusLg
                            color: Theme.alpha(Theme.muted, 0.5)
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Theme.radiusLg
                    color: Theme.alpha(Theme.muted, 0.5)
                }
            }
        }
    }
}
