import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Textarea variant: top toolbar (block-start + border-b) + bottom status bar (block-end + border-t).
InputGroup {
    width: 400

    InputGroupTextarea {
        implicitHeight: 180
        placeholderText: qsTr("console.log('Hello, world!');")
        font.family: Theme.fontMono
    }

    // Top: language icon + filename + refresh/copy
    InputGroupAddon {
        align: InputGroupAddon.BlockStart
        border: true
        LucideIcon { name: "braces"; size: 14; color: Theme.mutedForeground }
        InputGroupText {
            text: qsTr("script.js")
            font.family: Theme.fontMono
            Layout.fillWidth: true
        }
        InputGroupButton { kind: InputGroupButton.KindIconXs; iconName: "refresh-cw" }
        InputGroupButton { kind: InputGroupButton.KindIconXs; iconName: "copy" }
    }

    // Bottom: cursor position + run button (right-aligned)
    InputGroupAddon {
        align: InputGroupAddon.BlockEnd
        border: true
        InputGroupText { text: qsTr("Line 1, Column 1"); Layout.fillWidth: true }
        InputGroupButton {
            kind: InputGroupButton.KindSm
            variant: Button.Default
            text: qsTr("Run")
            trailingIconName: "corner-down-left"
        }
    }
}
