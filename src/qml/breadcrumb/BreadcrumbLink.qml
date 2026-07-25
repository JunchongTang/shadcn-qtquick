import QtQuick

/*!
    \qmltype BreadcrumbLink
    \inqmlmodule Shadcn
    \inherits Text
    \brief A clickable breadcrumb link.

    Maps to shadcn's \c{<a class="cn-breadcrumb-link">}. base-mira renders it in
    \c text-muted-foreground (the list's inherited color) and transitions to
    \c text-foreground on hover (\c transition-colors). Text is \c text-xs with
    \c relaxed line height. Set the inherited \c text property for the label.
*/
Text {
    id: root

    /*!
        \qmlsignal BreadcrumbLink::clicked()
        Emitted when the link is tapped/clicked.
    */
    signal clicked()

    color: hover.hovered ? Theme.foreground : Theme.mutedForeground
    font.pixelSize: Theme.textXs        // text-xs
    font.family: Theme.fontSans
    lineHeight: Theme.lineRelaxed       // /relaxed line height
    lineHeightMode: Text.ProportionalHeight
    verticalAlignment: Text.AlignVCenter
    Behavior on color { ColorAnimation { duration: Theme.durBase } }  // transition-colors

    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: root.clicked() }
}
