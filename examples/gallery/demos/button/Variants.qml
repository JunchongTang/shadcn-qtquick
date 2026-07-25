import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: qsTr("Default") }
    Button { text: qsTr("Secondary"); variant: Button.Secondary }
    Button { text: qsTr("Outline"); variant: Button.Outline }
    Button { text: qsTr("Ghost"); variant: Button.Ghost }
    Button { text: qsTr("Destructive"); variant: Button.Destructive }
    Button { text: qsTr("Link"); variant: Button.Link }
}
