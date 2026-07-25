import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Resizable
    \inqmlmodule Shadcn
    \inherits SplitView
    \brief A group of resizable split panels separated by draggable handles.
    \image resizable.png


    Resizable is the QML port of shadcn's base-mira \c ResizablePanelGroup /
    \c ResizablePanel / \c ResizableHandle trio, built on the Qt Quick Controls
    \c SplitView. Content items are declared directly as children and a handle is
    inserted automatically between adjacent panels, matching the composition of
    the reference where \c ResizableHandle sits between two \c ResizablePanel.

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

    \sa withHandle, framed
*/
C.SplitView {
    id: control

    /*!
        \qmlproperty enumeration Resizable::orientation
        Layout axis of the panel group (inherited from \c SplitView).
        \value Qt.Horizontal Panels sit side by side; handles are vertical
               strips. This is the default.
        \value Qt.Vertical Panels are stacked; handles are horizontal strips.
    */

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

    // Convenience flag: true when panels are laid out horizontally.
    readonly property bool _horizontal: orientation === Qt.Horizontal
    // Grab thickness of a handle: only a 1px line is drawn, the rest is a
    // transparent hit area that shares the panels' background (nearly invisible).
    readonly property real _thickness: Theme.space2

    clip: true

    background: Rectangle {
        color: "transparent"
        radius: control.framed ? Theme.radiusLg : 0
        border.width: control.framed ? 1 : 0
        border.color: Theme.border
    }

    handle: Item {
        id: hnd
        implicitWidth: control._horizontal ? control._thickness : control.width
        implicitHeight: control._horizontal ? control.height : control._thickness

        // True while the handle is hovered or being dragged.
        readonly property bool active: C.SplitHandle.hovered || C.SplitHandle.pressed

        // 1px separator line (always visible).
        Rectangle {
            anchors.centerIn: parent
            width: control._horizontal ? 1 : parent.width
            height: control._horizontal ? parent.height : 1
            color: hnd.active ? Theme.ring : Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }

        // Optional centre grip (bg-border, rounded-lg; 4x24 vertical, 24x4 horizontal).
        Rectangle {
            visible: control.withHandle
            anchors.centerIn: parent
            width: control._horizontal ? Theme.space1 : Theme.space6
            height: control._horizontal ? Theme.space6 : Theme.space1
            radius: Theme.radiusLg
            color: hnd.active ? Theme.ring : Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }

        // Show the split cursor on hover; does not accept presses, so it never
        // interferes with SplitView's own drag handling.
        HoverHandler {
            cursorShape: control._horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
        }
    }
}
