import QtQuick
import Shadcn

// Official button-group-input: Input and button form one group. ButtonGroup automatically flattens the
// adjacent inner corners of Input (left) and Button (right): Input rounded-left/square-right, Button rounded-right/square-left.
ButtonGroup {
    Input {
        width: 200
        placeholderText: qsTr("Search...")
    }
    Button { variant: Button.Outline; size: Button.Icon; iconName: "search" }
}
