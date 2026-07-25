import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarGroupLabel
    \inqmlmodule Shadcn
    \inherits Item
    \brief The muted caption at the top of a \l SidebarGroup.

    SidebarGroupLabel is the QML port of shadcn's \c SidebarGroupLabel
    (\c .cn-sidebar-group-label). It renders a small caption at \c h-8 (32px)
    with \c px-2 (8px) horizontal padding, \c text-xs, in
    \c sidebar-foreground/70.

    When the enclosing \l Sidebar is \l {Sidebar::collapsed}{collapsed} (the web
    component's \c collapsible=icon state), the label collapses to zero height
    and fades out (\c -mt-8 \c opacity-0), animating over 200ms linearly. The
    collapsed state is resolved by walking up the parent chain to the sidebar
    root.

    \note The reference CSS sets only color and size; a \c Medium font weight is
    used here for legibility.

    \sa SidebarGroup, Sidebar
*/
Item {
    id: control

    /*! \qmlproperty string SidebarGroupLabel::text \brief The caption text. */
    property string text: ""

    /*! \qmlproperty bool SidebarGroupLabel::collapsed
        \brief Mirrors the enclosing \l Sidebar's collapsed state (resolved via the parent chain). */
    property bool collapsed: {
        var p = parent
        while (p) {
            if (p._isSidebarRoot === true)
                return p.collapsed
            p = p.parent
        }
        return false
    }

    Layout.fillWidth: true
    implicitHeight: collapsed ? 0 : 32               // h-8, collapses via -mt-8
    opacity: collapsed ? 0 : 1
    clip: true

    Behavior on implicitHeight {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }

    Text {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8        // px-2
        anchors.rightMargin: 8
        height: 32
        text: control.text
        color: Theme.alpha(Theme.sidebarForeground, 0.7)
        font.pixelSize: Theme.textXs
        font.weight: Font.Medium
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}
