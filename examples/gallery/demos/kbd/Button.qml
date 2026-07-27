import QtQuick
import QtQuick.Layouts
import Shadcn

// Official kbd-button: Kbd placed inside a Button (trailing).
// Button only has a Lucide icon slot and can't take a Kbd directly, so override contentItem to inline "Accept" + Kbd.
Button {
    id: btn
    variant: Button.Outline

    contentItem: RowLayout {
        spacing: Theme.space1                    // gap-1
        Text {
            text: qsTr("Accept")
            color: Theme.foreground              // outline foreground color
            font.pixelSize: btn.font.pixelSize
            font.weight: btn.font.weight
            font.family: Theme.fontSans
            verticalAlignment: Text.AlignVCenter
        }
        Kbd { text: "⏎" }                   // data-icon=inline-end
    }
}
