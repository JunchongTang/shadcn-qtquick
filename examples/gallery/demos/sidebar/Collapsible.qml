import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Collapsible sidebar (collapsible=icon): top-bar SidebarTrigger toggles expanded/icon rail,
// the right-edge SidebarRail is also clickable to toggle. When collapsed the menu shows icons only
// (Tooltip on hover), group titles are hidden, and width transitions smoothly with duration-200 ease-linear.
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

        // ==== Sidebar (width driven and animated by its own implicitWidth) ====
        Sidebar {
            id: sidebar
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
                            name: "gallery-vertical-end"
                            size: 16
                            color: Theme.sidebarPrimaryForeground
                        }
                    }
                    ColumnLayout {
                        // Hide brand text when collapsed.
                        visible: !sidebar.collapsed
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Acme Inc")
                            color: Theme.sidebarForeground
                            font.pixelSize: Theme.textSm
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Enterprise")
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textXs
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            SidebarSeparator {}

            SidebarContent {
                SidebarGroup {
                    SidebarGroupLabel { text: qsTr("Platform") }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Playground"); iconName: "square-terminal"
                                active: shell.current === "playground"
                                onClicked: shell.current = "playground"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Models"); iconName: "bot"
                                active: shell.current === "models"
                                onClicked: shell.current = "models"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Documentation"); iconName: "book-open"
                                active: shell.current === "data-fetching"
                                onClicked: shell.current = "data-fetching"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Settings"); iconName: "settings-2"
                                active: shell.current === "settings"
                                onClicked: shell.current = "settings"
                            }
                        }
                    }
                }

                SidebarGroup {
                    SidebarGroupLabel { text: qsTr("Projects") }
                    SidebarMenu {
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Design Engineering"); iconName: "frame"
                                active: shell.current === "design"
                                onClicked: shell.current = "design"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Sales & Marketing"); iconName: "chart-pie"
                                active: shell.current === "sales"
                                onClicked: shell.current = "sales"
                            }
                        }
                        SidebarMenuItem {
                            SidebarMenuButton {
                                text: qsTr("Travel"); iconName: "map"
                                active: shell.current === "travel"
                                onClicked: shell.current = "travel"
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
                            text: qsTr("shadcn"); iconName: "user"
                        }
                    }
                }
            }
        }

        // ==== Content area ====
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Top bar: collapse trigger + title
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 8

                        SidebarTrigger { sidebar: sidebar }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 20
                            color: Theme.border
                        }

                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Data Fetching")
                            color: Theme.foreground
                            font.pixelSize: Theme.textSm
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: Theme.border
                    }
                }

                // Content placeholder
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 16
                    spacing: 16

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

    // ==== Edge rail: hugs the Sidebar's right edge, click to toggle collapse ====
    SidebarRail {
        sidebar: sidebar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        // Center seam aligned to the Sidebar's right border (rail is 16 wide, centered on the edge).
        x: sidebar.width - width / 2
    }
}
