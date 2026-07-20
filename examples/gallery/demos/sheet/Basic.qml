import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 sheet-demo:右侧滑入,编辑资料表单 + 底部 Save / Close。
Button {
    text: "Open"
    variant: Button.Outline
    onClicked: sheet.open()

    Sheet {
        id: sheet
        side: Sheet.Right
        title: qsTr("Edit profile")
        description: qsTr("Make changes to your profile here. Click save when you're done.")

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space3
            Label { text: "Name" }
            Input { Layout.fillWidth: true; text: "Pedro Duarte" }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space3
            Label { text: "Username" }
            Input { Layout.fillWidth: true; text: "@peduarte" }
        }

        footer: ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space2
            Button { Layout.fillWidth: true; text: "Save changes"; onClicked: sheet.close() }
            Button { Layout.fillWidth: true; text: "Close"; variant: Button.Outline; onClicked: sheet.close() }
        }
    }
}
