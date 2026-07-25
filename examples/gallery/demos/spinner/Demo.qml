import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 spinner-demo(带文本):Spinner 作为媒体图标 + 标题 + 右侧金额,置于 muted 列表项内。
// 注:官方用 Item / ItemMedia / ItemContent 组件(非本库基础件),此处用 muted 圆角容器近似。
Rectangle {
    id: item
    implicitWidth: 320                         // max-w-xs
    implicitHeight: row.implicitHeight + 2 * Theme.space4
    radius: 16                                 // [--radius:1rem]
    color: Theme.muted                         // Item variant="muted"

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Theme.space4
        anchors.rightMargin: Theme.space4
        spacing: Theme.space3

        Spinner { size: 16 }                   // ItemMedia
        Text {
            Layout.fillWidth: true
            text: qsTr("Processing payment...")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.family: Theme.fontSans
            elide: Text.ElideRight             // line-clamp-1
        }
        Text {
            text: "$100.00"                    // tabular-nums
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.family: Theme.fontMono
        }
    }
}
