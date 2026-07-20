import QtQuick
import QtQuick.Layouts
import Shadcn

// Custom Close Button —— 在 footer 放一个自定义 Close 按钮(对标 dialog-close-button)。
// 右上角默认关闭按钮保留(与官方示例一致,官方也未关闭它)。
Button {
    text: "Share"
    variant: Button.Outline
    onClicked: dialog.open()

    Dialog {
        id: dialog
        title: qsTr("Share link")
        description: qsTr("Anyone who has this link will be able to view this.")

        Input {
            width: dialog.availableWidth
            readOnly: true
            text: "https://ui.shadcn.com/docs/installation"
        }

        // footer 左对齐(sm:justify-start):自定义 Close 按钮
        footerContent: RowLayout {
            Button {
                text: qsTr("Close")
                variant: Button.Outline
                onClicked: dialog.close()
            }
            Item { Layout.fillWidth: true }
        }
    }
}
