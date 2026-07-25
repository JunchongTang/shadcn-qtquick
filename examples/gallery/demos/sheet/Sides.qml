import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 sheet-side:四个方向各一个触发器,用 side 属性设置滑入边。
Flow {
    spacing: Theme.space2

    Repeater {
        model: [
            { label: qsTr("top"),    side: Sheet.TopEdge },
            { label: qsTr("right"),  side: Sheet.RightEdge },
            { label: qsTr("bottom"), side: Sheet.BottomEdge },
            { label: qsTr("left"),   side: Sheet.LeftEdge }
        ]
        delegate: Button {
            required property var modelData
            text: modelData.label
            variant: Button.Outline
            onClicked: sheet.open()

            Sheet {
                id: sheet
                side: modelData.side
                title: qsTr("Edit profile")
                description: qsTr("Make changes to your profile here. Click save when you're done.")

                Text {
                    Layout.fillWidth: true
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do "
                             + "eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }

                footer: ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.space2
                    Button { Layout.fillWidth: true; text: qsTr("Save changes"); onClicked: sheet.close() }
                    Button { Layout.fillWidth: true; text: qsTr("Cancel"); variant: Button.Outline; onClicked: sheet.close() }
                }
            }
        }
    }
}
