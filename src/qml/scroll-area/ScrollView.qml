import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype ScrollView
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.ScrollView
    \brief A scroll container with thin, self-fading overlay scrollbars.

    ScrollView is the plain styled scroll container used across the gallery. It
    keeps the default behaviour of the Qt Quick Controls \c ScrollView (a single
    piece of content backed by a \c Flickable) and only restyles the vertical and
    horizontal scrollbars into thin overlay bars: a transparent track and a
    fully-rounded (\c rounded-full) thumb 10px thick (\c w-2.5 / \c h-2.5),
    painted with the muted-foreground token at 40% opacity, brightening to 60% on
    hover and 70% while pressed. The thumb fades out while idle or when the axis
    does not overflow.

    It differs from \l ScrollArea, which additionally wraps the content in a
    \c rounded-md bordered box and paints its thumb with the \c border token
    instead of the muted foreground.

    \section2 Content

    Place a single child item as the content; its size drives the scrollable
    range. The child is added through the inherited default (content) property of
    \c ScrollView, so it lands inside the backing \c Flickable.

    \section2 Orientation

    Orientation is implicit: whichever axis the content overflows on becomes
    scrollable. Both scrollbars are provided and appear only when the content
    exceeds the viewport on that axis.

    \section2 Scrollbar policy

    Each scrollbar defaults to \c {ScrollBar.AsNeeded}. Override it per axis via
    the attached \c {ScrollBar.vertical.policy} / \c {ScrollBar.horizontal.policy}.

    \qml
    ScrollView {
        width: 300; height: 200
        Column {
            Repeater { model: 50; delegate: Label { text: "Item " + index } }
        }
    }
    \endqml

    \sa ScrollArea
*/
// The file name matches the base type (ScrollView), so the base must be imported
// under an alias and used as C.ScrollView for the root.
C.ScrollView {
    id: control

    C.ScrollBar.vertical: C.ScrollBar {
        id: vbar
        parent: control
        anchors.top: control.top
        anchors.right: control.right
        anchors.bottom: control.bottom
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitWidth: 10               // w-2.5 = 10px thumb thickness
            radius: Theme.radiusFull        // rounded-full
            color: vbar.pressed ? Theme.alpha(Theme.mutedForeground, 0.7)
                 : vbar.hovered ? Theme.alpha(Theme.mutedForeground, 0.6)
                                : Theme.alpha(Theme.mutedForeground, 0.4)
            opacity: vbar.active ? 1.0 : 0.0   // fade out while idle / not scrollable
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }

    C.ScrollBar.horizontal: C.ScrollBar {
        id: hbar
        parent: control
        anchors.left: control.left
        anchors.right: control.right
        anchors.bottom: control.bottom
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitHeight: 10              // h-2.5 = 10px thumb thickness
            radius: Theme.radiusFull        // rounded-full
            color: hbar.pressed ? Theme.alpha(Theme.mutedForeground, 0.7)
                 : hbar.hovered ? Theme.alpha(Theme.mutedForeground, 0.6)
                                : Theme.alpha(Theme.mutedForeground, 0.4)
            opacity: hbar.active ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }
}
