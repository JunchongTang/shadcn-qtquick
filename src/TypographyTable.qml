pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// shadcn Typography table —— markdown 风格表格(非 data-table)。
// th/td: border px-4(16) py-2(8) text-left;th font-bold;tr even:bg-muted。
// even 计数按各自 <tbody> 内 nth-child:表头(奇)无底纹;正文行 index 1 → 偶(muted)。
// headers: 字符串数组;rows: 字符串数组的数组。列等宽分配。
ColumnLayout {
    id: root
    property var headers: []
    property var rows: []

    Layout.fillWidth: true
    spacing: 0

    component Cell: Rectangle {
        property string content: ""
        property bool header: false
        property color fill: "transparent"

        Layout.fillWidth: true
        Layout.preferredWidth: 1          // 等宽列
        implicitHeight: cellText.implicitHeight + 16   // py-2 上下各 8
        color: fill
        border.width: 1
        border.color: Theme.border

        Text {
            id: cellText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 16        // px-4
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            text: parent.content
            color: Theme.foreground
            font.family: Theme.fontSans
            font.pixelSize: Theme.textBase
            font.weight: parent.header ? Font.Bold : Font.Normal
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.Wrap
            textFormat: Text.PlainText
        }
    }

    // 表头
    RowLayout {
        Layout.fillWidth: true
        spacing: 0
        Repeater {
            model: root.headers
            delegate: Cell {
                required property string modelData
                content: modelData
                header: true
            }
        }
    }

    // 表体
    Repeater {
        model: root.rows
        delegate: RowLayout {
            id: bodyRow
            required property int index
            required property var modelData
            Layout.fillWidth: true
            spacing: 0
            Repeater {
                model: bodyRow.modelData
                delegate: Cell {
                    required property string modelData
                    content: modelData
                    fill: (bodyRow.index % 2 === 1) ? Theme.muted : "transparent"
                }
            }
        }
    }
}
