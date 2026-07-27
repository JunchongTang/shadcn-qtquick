import QtQuick
import QtQuick.Layouts
import Shadcn

// Sizes: default (h-7) and sm (h-6, font size + arrow scale down together).
RowLayout {
    spacing: 12

    NativeSelect {
        Layout.preferredWidth: 160
        size: NativeSelect.Default
        model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry")]
    }
    NativeSelect {
        Layout.preferredWidth: 160
        size: NativeSelect.Sm
        model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry")]
    }
}
