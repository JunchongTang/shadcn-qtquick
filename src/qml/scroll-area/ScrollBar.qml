import QtQuick
import QtQuick.Controls as C

/*!
    \qmltype ScrollBar
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls::ScrollBar
    \brief The scrollbar of \l ScrollArea, usable on any Flickable.

    A 10px \c bg-border thumb with fully rounded ends that fades in while the bar is
    \c active — the same look \l ScrollArea attaches to its own content. It lives in its
    own file so that views which are not wrapped in a ScrollArea (a TableView or TreeView
    brings its own scrolling) can attach the library's scrollbar instead of the plain
    control:

    \qml
    TreeView {
        ScrollBar.vertical: Shadcn.ScrollBar {}
    }
    \endqml

    \note The default \c policy is \c AsNeeded, matching ScrollArea.
*/
C.ScrollBar {
    id: control

    policy: C.ScrollBar.AsNeeded

    contentItem: Rectangle {
        implicitWidth: 10                   // w-2.5
        implicitHeight: 10                  // h-2.5
        radius: Theme.radiusFull            // rounded-full
        color: Theme.border                 // bg-border
        opacity: control.active ? 1.0 : 0.0 // fade out while idle / not scrollable
        Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
    }
    background: Rectangle { color: "transparent" }
}
