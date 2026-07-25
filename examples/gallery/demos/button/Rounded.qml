import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: qsTr("Get Started"); rounded: true }
    Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-up"; rounded: true }
}
