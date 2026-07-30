pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Resizable
    \inqmlmodule Shadcn
    \inherits SplitView
    \brief A group of resizable split panels separated by draggable handles.
    \image resizable.png


    Resizable is the QML port of shadcn's \c ResizablePanelGroup: a
    \c SplitView whose panels are declared directly as children, separated by a
    draggable handle inserted automatically between adjacent panels (matching
    the reference, where \c ResizableHandle sits between two \c ResizablePanel).

    Like the reference — where the demo's border comes from a \c {rounded-lg
    border} class on the group, not the component — Resizable draws no border of
    its own. Wrap it in a rounded, 1px-bordered container for the framed look.
    (A \c SplitView \c background item would suppress the built-in handle
    dragging, so the frame must stay on an enclosing item.)

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

    The handle is the 1px separator line itself, so the layout gap between panels
    is only 1px; on hover or while dragging it highlights from the \c border to
    the \c ring colour, and its mouse/touch grab area is widened to \l _thickness
    via \c containmentMask without growing the visual size. When \l withHandle is
    true, a small rounded grip is drawn in the centre of every handle.

    \sa withHandle
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

    // Convenience flag: true when panels are laid out horizontally.
    readonly property bool _horizontal: orientation === Qt.Horizontal
    // Mouse/touch grab thickness of a handle (the visual line stays 1px).
    readonly property real _thickness: Theme.space2

    // The handle IS the 1px separator line, so the layout gap between panels is
    // only 1px (matching shadcn). The grab area is widened to _thickness via
    // containmentMask WITHOUT growing the visual size (Qt SplitView pattern).
    handle: Rectangle {
        id: hnd
        implicitWidth: control._horizontal ? 1 : control.width
        implicitHeight: control._horizontal ? control.height : 1

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

        // Split cursor on hover; a HoverHandler only reacts to hover and never
        // grabs presses, so SplitView's own drag handling is intact.
        HoverHandler {
            cursorShape: control._horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
        }
    }
}
