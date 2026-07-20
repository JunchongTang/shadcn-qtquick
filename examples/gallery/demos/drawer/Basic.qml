import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as QC
import LucideIcons
import Shadcn

// Faithful port of the official drawer-demo ("Move Goal"): a bottom drawer with a
// centered handle, a large calorie goal flanked by round -/+ steppers, a small bar
// chart, and Submit / Cancel footer buttons.
Button {
    text: qsTr("Open Drawer")
    variant: Button.Outline
    onClicked: drawer.open()

    property int goal: 350
    // Relative bar heights (0..1) approximating the demo's activity chart.
    readonly property var bars: [0.4, 0.3, 0.5, 0.45, 0.62, 0.55, 0.78, 0.68, 0.9, 0.72, 0.6, 0.5, 0.66]

    // Round outline stepper button (h-8 w-8 rounded-full) used for -/+.
    component Stepper: QC.AbstractButton {
        id: step
        property string iconName: ""
        implicitWidth: 32
        implicitHeight: 32
        hoverEnabled: true
        opacity: enabled ? 1.0 : 0.5
        background: Rectangle {
            radius: height / 2
            color: step.hovered ? Theme.alpha(Theme.input, 0.5) : "transparent"
            border.width: 1
            border.color: Theme.border
        }
        contentItem: Item {
            LucideIcon {
                anchors.centerIn: parent
                name: step.iconName
                size: 16
                color: Theme.foreground
            }
        }
    }

    Drawer {
        id: drawer
        side: "bottom"
        title: qsTr("Move Goal")
        description: qsTr("Set your daily activity goal.")

        // Body centered at max-w-sm (mx-auto w-full max-w-sm).
        Item {
            Layout.fillWidth: true
            implicitHeight: bodyCol.implicitHeight
            ColumnLayout {
                id: bodyCol
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, 384)
                spacing: Theme.space3

            // Goal stepper: - [ big number / label ] +
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.space4

                Stepper {
                    iconName: "minus"
                    enabled: goal > 200
                    onClicked: goal -= 10
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: goal
                        color: Theme.foreground
                        font.pixelSize: 64            // ~text-7xl
                        font.weight: Font.Bold
                        font.letterSpacing: -2        // tracking-tighter
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("CALORIES/DAY")
                        color: Theme.mutedForeground
                        font.pixelSize: 11            // text-[0.70rem] uppercase
                        font.letterSpacing: 0.5
                    }
                }
                Stepper {
                    iconName: "plus"
                    onClicked: goal += 10
                }
            }

            // Activity bar chart (mt-3 h-[120px]).
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: Theme.space3
                Layout.preferredHeight: 120
                spacing: Theme.space2
                Repeater {
                    model: bars
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
                width: Math.min(parent.width, 384)    // mx-auto max-w-sm
                spacing: Theme.space2
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Submit")
                    onClicked: drawer.close()
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Cancel")
                    variant: Button.Outline
                    onClicked: drawer.close()
                }
            }
        }
    }
}
