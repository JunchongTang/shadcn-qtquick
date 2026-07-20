import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: "Disabled"; enabled: false }
    Button { text: "Disabled"; variant: Button.Outline; enabled: false }
}
