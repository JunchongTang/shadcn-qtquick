import QtQuick
import Shadcn

// 基础:按钮打开承载 Command 的 Dialog(command-basic)。
Button {
    text: qsTr("Open Menu")
    variant: Button.Outline
    onClicked: dlg.open()

    Dialog {
        id: dlg
        padding: 0                 // command-dialog p-0
        showCloseButton: false
        implicitWidth: 420
        onOpened: cmd.focusInput()

        Command {
            id: cmd
            model: [
                { heading: qsTr("Suggestions"), items: [
                    { text: qsTr("Calendar") },
                    { text: qsTr("Search Emoji") },
                    { text: qsTr("Calculator") }
                ] }
            ]
            onTriggered: dlg.close()
        }
    }
}
