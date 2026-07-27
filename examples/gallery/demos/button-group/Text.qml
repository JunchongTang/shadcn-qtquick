import QtQuick
import Shadcn

// Official API example (ButtonGroupText): display a piece of text within the group (bg-muted pill), joined to Input.
ButtonGroup {
    ButtonGroupText { text: qsTr("Currency") }
    Input {
        width: 200
        placeholderText: qsTr("Type something here...")
    }
}
