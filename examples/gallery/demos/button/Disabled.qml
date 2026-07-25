import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: qsTr("Disabled"); enabled: false }
    Button { text: qsTr("Disabled"); variant: Button.Outline; enabled: false }
}
