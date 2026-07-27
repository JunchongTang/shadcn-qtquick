import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Full app sidebar: header brand + several grouped menus (icon + text) + footer user item,
// paired with a simplified inset content area on the right, all inside a bordered rounded container.
// Simplified (see report): collapsible icon rail / mobile sheet / SidebarTrigger / inset rounded float are not implemented.
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

        // ==== Sidebar ====
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
                            text: qsTr("Documentation")
                            color: Theme.sidebarForeground
                            font.pixelSize: Theme.textSm
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("v2.0.0")
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
                    SidebarGroupLabel { text: qsTr("Getting Started") }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Installation"); iconName: "download"
                                active: shell.current === "installation"
                                onClicked: shell.current = "installation"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Project Structure"); iconName: "folder"
                                active: shell.current === "structure"
                                onClicked: shell.current = "structure"
                            }
                        }
                    }
                }

                SidebarGroup {
                    SidebarGroupLabel { text: qsTr("Build Your Application") }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Routing"); iconName: "layout"
                                active: shell.current === "routing"
                                onClicked: shell.current = "routing"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Data Fetching"); iconName: "code"
                                active: shell.current === "data-fetching"
                                onClicked: shell.current = "data-fetching"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Rendering"); iconName: "monitor"
                                active: shell.current === "rendering"
                                onClicked: shell.current = "rendering"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Caching"); iconName: "bookmark"
                                active: shell.current === "caching"
                                onClicked: shell.current = "caching"
                            }
                        }
                    }
                }

                SidebarGroup {
                    SidebarGroupLabel { text: qsTr("API Reference") }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Components"); iconName: "file-code"
                                active: shell.current === "components"
                                onClicked: shell.current = "components"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("File Conventions"); iconName: "file"
                                active: shell.current === "conventions"
                                onClicked: shell.current = "conventions"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("CLI"); iconName: "keyboard"
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
                            text: qsTr("Settings"); iconName: "settings"
                            active: shell.current === "settings"
                            onClicked: shell.current = "settings"
                        }
                    }
                    SidebarMenuItem {
                        SidebarMenuButton {
                            text: qsTr("shadcn"); iconName: "user"
                        }
                    }
                }
            }
        }

        // ==== Simplified inset content area ====
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Text {
                    text: qsTr("Data Fetching")
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
