import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 spinner-empty:空状态占位中的加载态 —— 媒体图标位放 Spinner。
// 注:官方用 Empty / EmptyMedia / EmptyHeader 等组件(非本库基础件),此处用居中列布局近似。
ColumnLayout {
    id: empty
    width: 360
    spacing: Theme.space4

    // EmptyMedia variant="icon":muted 圆角方框 + 居中图标。
    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: 40
        implicitHeight: 40
        radius: Theme.radiusLg
        color: Theme.muted
        border.width: 1
        border.color: Theme.border
        Spinner { anchors.centerIn: parent; size: 20 }
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Processing your request")
        color: Theme.foreground
        font.pixelSize: Theme.textSm
        font.weight: Font.Medium
        font.family: Theme.fontSans
    }
    Text {
        Layout.fillWidth: true
        Layout.topMargin: -Theme.space2
        text: qsTr("Please wait while we process your request. Do not refresh the page.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        font.family: Theme.fontSans
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Theme.space2
        text: qsTr("Cancel")
        size: Button.Sm
        variant: Button.Outline
    }
}
