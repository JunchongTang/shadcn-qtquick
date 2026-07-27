import QtQuick
import Shadcn

// Official native-select-disabled: whole control disabled (opacity-50 + non-interactive).
NativeSelect {
    width: 180
    enabled: false
    currentIndex: -1
    placeholder: qsTr("Disabled")
    model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry")]
}
