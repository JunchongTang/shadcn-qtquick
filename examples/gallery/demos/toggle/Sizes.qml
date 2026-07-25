import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Toggle { variant: Toggle.Outline; size: Toggle.Sm; text: qsTr("Small") }
    Toggle { variant: Toggle.Outline; size: Toggle.Default; text: qsTr("Default") }
    Toggle { variant: Toggle.Outline; size: Toggle.Lg; text: qsTr("Large") }
}
