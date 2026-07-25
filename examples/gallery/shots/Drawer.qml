import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as QC
import LucideIcons
import Shadcn

// Bottom drawer ("Move Goal"), opened over a little page content.
Rectangle {
    id: stage
    color: Theme.background
    implicitWidth: 680
    implicitHeight: 620

    property int goal: 350
    readonly property var bars: [0.4, 0.3, 0.5, 0.45, 0.62, 0.55, 0.78, 0.68, 0.9, 0.72, 0.6, 0.5, 0.66]

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        text: qsTr("Activity")
        color: Theme.foreground
        font.pixelSize: 24
        font.weight: Font.DemiBold
    }

    component Stepper: QC.AbstractButton {
        id: step
        property string iconName: ""
        implicitWidth: 32
        implicitHeight: 32
        opacity: enabled ? 1.0 : 0.5
        background: Rectangle {
            radius: height / 2
            color: "transparent"
            border.width: 1
            border.color: Theme.border
        }
        contentItem: Item {
            LucideIcon { anchors.centerIn: parent; name: step.iconName; size: 16; color: Theme.foreground }
        }
    }

    Drawer {
        id: drawer
        side: "bottom"
        title: qsTr("Move Goal")
        description: qsTr("Set your daily activity goal.")

        Item {
            Layout.fillWidth: true
            implicitHeight: bodyCol.implicitHeight
            ColumnLayout {
                id: bodyCol
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, 384)
                spacing: Theme.space3

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.space4
                    Stepper { iconName: "minus"; enabled: stage.goal > 200; onClicked: stage.goal -= 10 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: stage.goal
                            color: Theme.foreground
                            font.pixelSize: 64
                            font.weight: Font.Bold
                            font.letterSpacing: -2
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: qsTr("CALORIES/DAY")
                            color: Theme.mutedForeground
                            font.pixelSize: 11
                            font.letterSpacing: 0.5
                        }
                    }
                    Stepper { iconName: "plus"; onClicked: stage.goal += 10 }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.space3
                    Layout.preferredHeight: 120
                    spacing: Theme.space2
                    Repeater {
                        model: stage.bars
                        delegate: Item {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: parent.height * modelData
                                radius: 2
                                color: Theme.alpha(Theme.foreground, 0.9)
                            }
                        }
                    }
                }
            }
        }

        footer: Item {
            implicitHeight: fcol.implicitHeight
            ColumnLayout {
                id: fcol
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, 384)
                spacing: Theme.space2
                Button { Layout.fillWidth: true; text: qsTr("Submit") }
                Button { Layout.fillWidth: true; text: qsTr("Cancel"); variant: Button.Outline }
            }
        }
    }

    Component.onCompleted: drawer.open()
}
