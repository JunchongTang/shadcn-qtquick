import QtQuick
import QtQuick.Layouts

// shadcn ItemDescription —— 描述文本:text-muted-foreground text-xs/relaxed,line-clamp-2。
Text {
    readonly property string itemSlot: "item-description"

    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    maximumLineCount: 2          // line-clamp-2
    elide: Text.ElideRight
    Layout.fillWidth: true
}
