import QtQuick

// shadcn BreadcrumbLink —— 可点击链接(= <a class="cn-breadcrumb-link">)。
// base-mira: 默认 text-muted-foreground(继承自 list),hover:text-foreground + transition-colors。
Text {
    id: root

    signal clicked()

    color: hover.hovered ? Theme.foreground : Theme.mutedForeground
    font.pixelSize: Theme.textXs        // text-xs
    font.family: Theme.fontSans
    verticalAlignment: Text.AlignVCenter
    Behavior on color { ColorAnimation { duration: Theme.durBase } }  // transition-colors

    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: root.clicked() }
}
