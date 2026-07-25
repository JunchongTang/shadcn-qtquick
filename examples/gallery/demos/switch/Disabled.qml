import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Switch { enabled: false }
    Label { text: qsTr("Disabled"); enabled: false }
}
