import QtQuick
import QtQuick.Layouts
import Shadcn

// 尺寸:default(h-7)与 sm(h-6,字号 + 箭头同缩)。
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
