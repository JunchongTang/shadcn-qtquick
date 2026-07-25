import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Badge { text: qsTr("Default") }
    Badge { text: qsTr("Secondary"); variant: Badge.Secondary }
    Badge { text: qsTr("Outline"); variant: Badge.Outline }
    Badge { text: qsTr("Destructive"); variant: Badge.Destructive }
}
