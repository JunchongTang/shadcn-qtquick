import QtQuick
import QtQuick.Layouts

// shadcn Typography list —— ul ml-6 list-disc [&>li]:mt-2。
// 项目符号列表:左缩进 24px(ml-6)、项间距 8px(mt-2)、实心圆点(list-disc)。
// items: 字符串数组。外层 my-6 由布局负责。
ColumnLayout {
    id: root
    property var items: []

    Layout.fillWidth: true
    Layout.leftMargin: 24          // ml-6
    spacing: 8                       // [&>li]:mt-2

    Repeater {
        model: root.items
        delegate: RowLayout {
            required property string modelData
            Layout.fillWidth: true
            spacing: 8

            Text {
                Layout.alignment: Qt.AlignTop
                text: "•"          // list-disc
                color: Theme.foreground
                font.family: Theme.fontSans
                font.pixelSize: Theme.textBase
                lineHeight: 1.6
                lineHeightMode: Text.ProportionalHeight
            }
            Text {
                Layout.fillWidth: true
                text: modelData
                color: Theme.foreground
                font.family: Theme.fontSans
                font.pixelSize: Theme.textBase
                lineHeight: 1.6
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }
        }
    }
}
