import QtQuick
import Shadcn

// 基础:按钮打开承载 Command 的 Dialog(command-basic)。
Button {
    text: "Open Menu"
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
                { heading: "Suggestions", items: [
                    { text: "Calendar" },
                    { text: "Search Emoji" },
                    { text: "Calculator" }
                ] }
            ]
            onTriggered: dlg.close()
        }
    }
}
