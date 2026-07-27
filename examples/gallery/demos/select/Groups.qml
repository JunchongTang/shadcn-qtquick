import QtQuick
import Shadcn

// Groups: { header } in the model renders as a group title, { separator: true } renders as a divider.
Select {
    width: 200
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select a fruit")
    model: [
        { header: qsTr("Fruits") },
        { text: qsTr("Apple") },
        { text: qsTr("Banana") },
        { text: qsTr("Blueberry") },
        { separator: true },
        { header: qsTr("Vegetables") },
        { text: qsTr("Carrot") },
        { text: qsTr("Broccoli") },
        { text: qsTr("Spinach") }
    ]
}
