import QtQuick
import Shadcn

// Whole Select disabled (enabled:false → opacity 0.5, non-interactive).
// Per-item disable: add { disabled: true } to the model entry (see Grapes in the list).
Select {
    width: 200
    enabled: false
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select a fruit")
    model: [
        { text: qsTr("Apple") },
        { text: qsTr("Banana") },
        { text: qsTr("Blueberry") },
        { text: qsTr("Grapes"), disabled: true },
        { text: qsTr("Pineapple") }
    ]
}
