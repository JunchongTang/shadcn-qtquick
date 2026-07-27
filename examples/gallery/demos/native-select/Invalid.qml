import QtQuick
import Shadcn

// Official native-select-invalid: aria-invalid → destructive border + destructive ring.
NativeSelect {
    width: 180
    invalid: true
    currentIndex: -1
    placeholder: qsTr("Error state")
    model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry")]
}
