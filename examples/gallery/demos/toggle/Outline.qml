import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Toggle { variant: Toggle.Outline; iconName: "italic"; text: qsTr("Italic") }
    Toggle { variant: Toggle.Outline; iconName: "bold"; text: qsTr("Bold") }
}
