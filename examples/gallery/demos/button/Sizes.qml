import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: "Extra small"; size: Button.Xs }
    Button { text: "Small"; size: Button.Sm }
    Button { text: "Default" }
    Button { text: "Large"; size: Button.Lg }
}
