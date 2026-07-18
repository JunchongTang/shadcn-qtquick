import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn Dialog(模态对话框)。文件名 Dialog 与基类 Dialog 同名 → 别名导入(as C),根用 C.Dialog。
// title 继承自基类 Dialog,直接使用;description 为本组件新增。body 由使用方作为默认内容填入,footer 交给使用方。
C.Dialog {
    id: control

    property string description: ""       // header 副标题(muted)
    property bool showCloseButton: true   // 右上角关闭按钮(对标 web 的 XIcon)

    modal: true
    anchors.centerIn: parent              // 居中于父项
    implicitWidth: 360
    padding: Theme.space4                 // 正文区内边距 p-4

    // 模态遮罩:black/80(对标 DialogOverlay)
    QQC.Overlay.modal: Rectangle { color: Theme.alpha("#000000", 0.8) }

    // 内容面:popover 底 + 1px 边框 + radiusXl(对标 rounded-xl)+ 轻微投影
    background: Rectangle {
        color: Theme.popover
        radius: Theme.radiusXl
        border.width: 1
        border.color: Theme.border
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.alpha("#000000", 0.25)
            shadowBlur: 0.5
            shadowVerticalOffset: 4
        }
    }

    // 头部:标题 + 描述 + 关闭按钮。header 位于 padding 之外,故自带 space4 内边距。
    header: Item {
        visible: control.title !== "" || control.description !== "" || control.showCloseButton
        implicitHeight: visible
            ? Math.max(headerCol.implicitHeight, control.showCloseButton ? 24 : 0) + Theme.space4
            : 0

        ColumnLayout {
            id: headerCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: Theme.space4
            anchors.rightMargin: control.showCloseButton ? Theme.space4 + 24 : Theme.space4
            anchors.topMargin: Theme.space4
            spacing: Theme.space1        // gap-1

            Text {
                visible: control.title !== ""
                text: control.title
                color: Theme.foreground
                font.pixelSize: Theme.textBase   // text-sm ≈ 14
                font.weight: Font.Medium
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Text {
                visible: control.description !== ""
                text: control.description
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }

        IconButton {
            id: closeBtn
            visible: control.showCloseButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Theme.space2
            anchors.rightMargin: Theme.space2
            iconName: "x"
            variant: IconButton.Ghost
            size: IconButton.Small
            onClicked: control.close()
        }
    }

    // 弹出动效:fade + zoom-95(对标 data-open:fade-in/zoom-in-95)
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
    }
}
