import QtQuick
import Shadcn

// Official native-select-demo: "Select status" placeholder + status options.
NativeSelect {
    width: 180
    currentIndex: -1
    placeholder: qsTr("Select status")
    model: [qsTr("Todo"), qsTr("In Progress"), qsTr("Done"), qsTr("Cancelled")]
}
