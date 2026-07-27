import QtQuick
import Shadcn

// Official native-select-groups: optgroup grouping -- { header } entries in the model render as group titles (non-selectable).
NativeSelect {
    width: 200
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select department")
    model: [
        { header: qsTr("Engineering") },
        { text: qsTr("Frontend") },
        { text: qsTr("Backend") },
        { text: qsTr("DevOps") },
        { header: qsTr("Sales") },
        { text: qsTr("Sales Rep") },
        { text: qsTr("Account Manager") },
        { text: qsTr("Sales Director") },
        { header: qsTr("Operations") },
        { text: qsTr("Customer Support") },
        { text: qsTr("Product Manager") },
        { text: qsTr("Operations Manager") }
    ]
}
