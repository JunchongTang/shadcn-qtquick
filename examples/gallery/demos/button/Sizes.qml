import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: qsTr("Extra small"); size: Button.Xs }
    Button { text: qsTr("Small"); size: Button.Sm }
    Button { text: qsTr("Default") }
    Button { text: qsTr("Large"); size: Button.Lg }
}
