import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 160
    spacing: 12
    RowLayout { spacing: 8; Switch { size: Switch.Sm } Label { text: qsTr("Small") } }
    RowLayout { spacing: 8; Switch {} Label { text: qsTr("Default") } }
}
