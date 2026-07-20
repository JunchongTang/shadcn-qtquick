import QtQuick
import QtQuick.Layouts

// shadcn CardDescription —— text-muted-foreground text-xs/relaxed。
Text {
    Layout.fillWidth: true
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
}
