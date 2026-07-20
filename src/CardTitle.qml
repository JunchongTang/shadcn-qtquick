import QtQuick
import QtQuick.Layouts

// shadcn CardTitle —— text-sm font-medium(leading-none)。
Text {
    Layout.fillWidth: true
    color: Theme.cardForeground
    font.pixelSize: Theme.textSm
    font.weight: Font.Medium
    wrapMode: Text.Wrap
}
