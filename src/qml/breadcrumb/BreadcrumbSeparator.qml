import QtQuick

/*!
    \qmltype BreadcrumbSeparator
    \inqmlmodule Shadcn
    \inherits Item
    \brief Visual separator between breadcrumb items.

    Maps to shadcn's \c{<li class="cn-breadcrumb-separator">} whose
    \c{[&>svg]:size-3.5} sizes the glyph to 14px. Defaults to a chevron-right
    icon; set \l iconName to use another Lucide glyph (e.g. \c "dot" for the
    dotted-separator variant). Colored with \c text-muted-foreground to match
    the list.
*/
Item {
    id: root

    /*!
        \qmlproperty string BreadcrumbSeparator::iconName
        Name of the Lucide icon used as the separator glyph. Defaults to
        \c "chevron-right".
    */
    property string iconName: "chevron-right"

    implicitWidth: 14                   // svg size-3.5
    implicitHeight: 14

    Icon {
        anchors.centerIn: parent
        name: root.iconName
        size: 14
        color: Theme.mutedForeground
    }
}
