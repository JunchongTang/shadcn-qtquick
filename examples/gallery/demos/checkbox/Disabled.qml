import QtQuick
import QtQuick.Layouts
import Shadcn

// disabled —— blocks interaction and lowers overall opacity.
ColumnLayout {
    spacing: 12
    Checkbox { text: qsTr("Enable notifications"); enabled: false }
    Checkbox { text: qsTr("Enable notifications"); enabled: false; checked: true }
}
