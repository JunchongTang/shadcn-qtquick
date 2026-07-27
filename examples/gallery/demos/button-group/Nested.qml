import QtQuick
import Shadcn

// Official button-group-nested: outer wraps multiple ButtonGroups -> gap-2 between groups (outer Row spacing 8).
// Structure: [+] icon button  |  InputGroup (text field + inline-end embedded audio-lines icon button).
// Note: officially the inner layer is <ButtonGroup> wrapping <InputGroup>, the inline-end addon is a voice icon with a Tooltip;
//     here approximated with InputGroupButton (ghost icon), tooltip omitted.
Row {
    spacing: 8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "plus" }
    }
    InputGroup {
        width: 260
        InputGroupInput { placeholderText: qsTr("Send a message...") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupButton {
                kind: InputGroupButton.KindIconXs
                iconName: "audio-lines"
            }
        }
    }
}
