import QtQuick
import QtQuick.Layouts
import Shadcn

// Single keys: each Kbd shows one key on its own (modifier symbols / Enter / Esc / arrow keys).
RowLayout {
    spacing: Theme.space2

    Kbd { text: "⌘" }
    Kbd { text: "⇧" }
    Kbd { text: "⏎" }        // Enter
    Kbd { text: qsTr("Esc") }
    Kbd { text: "↑" }
}
