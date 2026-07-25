import QtQuick
import LucideIcons

/*!
    \qmltype BreadcrumbEllipsis
    \inqmlmodule Shadcn
    \inherits Item
    \brief Collapsed-trail indicator (an ellipsis glyph).

    Maps to shadcn's \c{<span class="cn-breadcrumb-ellipsis">} with
    \c{size-4 [&>svg]:size-3.5}: a 16px container holding a 14px ellipsis icon.
    Colored with \c text-muted-foreground to match the list. Commonly placed
    inside a dropdown trigger to reveal hidden items.
*/
Item {
    implicitWidth: 16                   // size-4
    implicitHeight: 16

    LucideIcon {
        anchors.centerIn: parent
        name: "ellipsis"
        size: 14                        // svg size-3.5
        color: Theme.mutedForeground
    }
}
