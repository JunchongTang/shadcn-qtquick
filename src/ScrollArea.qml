import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype ScrollArea
    \inqmlmodule Shadcn
    \inherits ScrollView
    \brief A rounded, bordered scroll container with thin overlay scrollbars.

    ScrollArea ports shadcn's base-mira \c .cn-scroll-area. It wraps a single
    piece of content in a \c rounded-md bordered box and overlays a thin
    scrollbar (\c w-2.5 / \c h-2.5, i.e. 10px) whose thumb is painted with the
    \c border token and fully rounded (\c rounded-full). Content is clipped to
    the box; the scrollbars sit 1px inside the border (\c p-px).

    It differs from \l ScrollView in two ways: ScrollArea adds the rounded
    border container, and its thumb uses the \c border token instead of the
    muted foreground.

    \section2 Content

    Place a single child item as the content; its size drives the scrollable
    range. The child is added through the inherited default (content) property
    of \c ScrollView, so it lands inside the backing \c Flickable.

    \section2 Orientation

    Orientation is implicit: whichever axis the content overflows on becomes
    scrollable. Both the vertical and horizontal scrollbars are provided and
    appear only when the content exceeds the viewport on that axis.

    \section2 Scrollbar policy

    Each scrollbar defaults to \c {ScrollBar.AsNeeded}. Override it per axis via
    the attached \c {ScrollBar.vertical.policy} / \c {ScrollBar.horizontal.policy}.

    \qml
    ScrollArea {
        width: 192; height: 288          // h-72 w-48
        Column {
            padding: Theme.space4
            Repeater { model: 50; delegate: Label { text: "Item " + index } }
        }
    }
    \endqml

    \sa ScrollView
*/
C.ScrollView {
    id: control

    clip: true

    // rounded-md bordered container. Content is clipped to the rectangular
    // bounds; the rounded stroke overlays the four corners.
    background: Rectangle {
        radius: Theme.radiusMd          // rounded-md = 8
        color: "transparent"
        border.width: 1
        border.color: Theme.border
    }

    C.ScrollBar.vertical: C.ScrollBar {
        id: vbar
        parent: control
        anchors.top: control.top
        anchors.right: control.right
        anchors.bottom: control.bottom
        anchors.margins: 1              // p-px: inset 1px to sit inside the border
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitWidth: 10           // w-2.5
            radius: Theme.radiusFull    // rounded-full
            color: Theme.border         // bg-border
            opacity: vbar.active ? 1.0 : 0.0   // fade out while idle / not scrollable
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }

    C.ScrollBar.horizontal: C.ScrollBar {
        id: hbar
        parent: control
        anchors.left: control.left
        anchors.right: control.right
        anchors.bottom: control.bottom
        anchors.margins: 1
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitHeight: 10          // h-2.5
            radius: Theme.radiusFull    // rounded-full
            color: Theme.border         // bg-border
            opacity: hbar.active ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }
}
