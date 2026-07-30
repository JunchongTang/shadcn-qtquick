pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Resizable
    \inqmlmodule Shadcn
    \inherits Item
    \brief A group of resizable split panels separated by draggable handles.
    \image resizable.png


    Resizable is the QML port of shadcn's base-mira \c ResizablePanelGroup /
    \c ResizablePanel / \c ResizableHandle trio. It wraps a Qt Quick Controls
    \c SplitView in a thin container that draws the optional \l framed border.
    Content items are declared directly as children (forwarded to the inner
    SplitView) and a handle is inserted automatically between adjacent panels,
    matching the composition of the reference where \c ResizableHandle sits
    between two \c ResizablePanel.

    Each panel controls its own size through the \c SplitView attached
    properties (\c SplitView.preferredWidth, \c SplitView.fillWidth,
    \c SplitView.minimumWidth, and the height equivalents). Because those are
    attached properties, a consumer file must \c {import QtQuick.Controls}.

    \qml
    Resizable {
        orientation: Qt.Horizontal
        Item { SplitView.preferredWidth: 190; SplitView.minimumWidth: 60 }
        Item { SplitView.fillWidth: true;      SplitView.minimumWidth: 60 }
    }
    \endqml

    The handle paints a 1px separator line in the \c border color; on hover or
    while dragging it highlights to the \c ring color. When \l withHandle is
    true, a small rounded grip is drawn in the centre of every handle.

    \note The border is drawn by the wrapping container rather than the
    SplitView's \c background: a \c background item on a \c SplitView suppresses
    its built-in handle dragging (any item overlapping the handle region defeats
    the handle hit-test), which is why the frame lives on the outer container and
    the inner SplitView is left background-free.

    \sa withHandle, framed
*/
Item {
    id: control

    /*!
        \qmlproperty enumeration Resizable::orientation
        Layout axis of the panel group.
        \value Qt.Horizontal Panels sit side by side; handles are vertical
               strips. This is the default.
        \value Qt.Vertical Panels are stacked; handles are horizontal strips.
    */
    property int orientation: Qt.Horizontal

    /*!
        \qmlproperty bool Resizable::withHandle
        When true, a small rounded grip (\c .cn-resizable-handle-icon) is drawn
        in the centre of every handle: a 4x24 pill on a vertical handle and a
        24x4 pill on a horizontal one. Defaults to \c false.
    */
    property bool withHandle: false

    /*!
        \qmlproperty bool Resizable::framed
        When true, the group is wrapped in a \c rounded-lg, 1px \c border frame
        (the demo default). Set to \c false for a nested inner group so the
        outer frame is not doubled. Defaults to \c true.
    */
    property bool framed: true

    /*!
        \qmlproperty list<QtObject> Resizable::content
        \qmldefault
        The panels of the group; forwarded to the inner \c SplitView so the
        \c SplitView attached size properties apply to each declared panel.
    */
    default property alias content: split.contentData

    // Convenience flag: true when panels are laid out horizontally.
    readonly property bool _horizontal: orientation === Qt.Horizontal
    // Grab thickness of a handle: only a 1px line is drawn, the rest is a
    // transparent hit area that shares the panels' background (nearly invisible).
    readonly property real _thickness: Theme.space2

    implicitWidth: split.implicitWidth
    implicitHeight: split.implicitHeight

    // Frame border, drawn behind the SplitView; the panels are transparent so
    // the 1px ring shows through at the edges. Kept off the SplitView's own
    // `background` because a background item suppresses handle dragging.
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: control.framed ? Theme.radiusLg : 0
        border.width: control.framed ? 1 : 0
        border.color: Theme.border
    }

    C.SplitView {
        id: split
        anchors.fill: parent
        orientation: control.orientation
        clip: true

        // The handle IS the 1px separator line, so the layout gap between panels
        // is only 1px (matching shadcn). The mouse/touch grab area is widened to
        // _thickness via containmentMask WITHOUT growing the visual size, so a
        // thin divider stays easy to grab (Qt SplitView containmentMask pattern).
        handle: Rectangle {
            id: hnd
            implicitWidth: control._horizontal ? 1 : split.width
            implicitHeight: control._horizontal ? split.height : 1

            // True while the handle is hovered or being dragged.
            readonly property bool active: C.SplitHandle.hovered || C.SplitHandle.pressed
            color: active ? Theme.ring : Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durFast } }

            // Expanded hit area (centred on the 1px line), for mouse and touch.
            containmentMask: Item {
                x: (hnd.width - width) / 2
                y: (hnd.height - height) / 2
                width: control._horizontal ? control._thickness : hnd.width
                height: control._horizontal ? hnd.height : control._thickness
            }

            // Optional centre grip (bg-border, rounded-lg; 4x24 vertical, 24x4
            // horizontal), straddling the 1px line.
            Rectangle {
                visible: control.withHandle
                anchors.centerIn: parent
                width: control._horizontal ? Theme.space1 : Theme.space6
                height: control._horizontal ? Theme.space6 : Theme.space1
                radius: Theme.radiusLg
                color: hnd.active ? Theme.ring : Theme.border
                Behavior on color { ColorAnimation { duration: Theme.durFast } }
            }

            // Split cursor on hover; a HoverHandler only reacts to hover and
            // never grabs presses, so SplitView's own drag handling is intact.
            HoverHandler {
                cursorShape: control._horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
            }
        }
    }
}
