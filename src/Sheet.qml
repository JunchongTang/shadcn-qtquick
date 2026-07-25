import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype Sheet
    \inqmlmodule Shadcn
    \inherits Drawer
    \brief An edge-anchored panel that slides in to complement the main content.
    \image sheet.png


    Sheet is the shadcn (base-mira) port of the sheet dialog. It wraps the Qt
    Quick Controls \c Drawer, which natively handles the "pin to a window edge +
    slide in/out + modal backdrop" behaviour so no manual positioning is needed.
    The visuals are aligned pixel-for-pixel to \c {style-mira.css} (the
    \c cn-sheet-* rules: overlay / content / close / header / footer / title /
    description).

    The entry \l side maps to the base type's \c edge. Horizontal sheets (left,
    right) span the full height at three quarters of the window width, capped at
    \c max-w-sm (384) with an inner border on the edge facing the viewport.
    Vertical sheets (top, bottom) span the full width, size to their content
    (\c h-auto, capped at the window height) and carry an inner border on their
    inward edge.

    The layout is a header (\l title / \l description), the default content slot
    (the body), and an optional \l footer pinned to the bottom, with a close
    button in the top-right corner.

    Because the file name shadows the base type, it is imported aliased
    (\c {as C}) and the root is \c C.Drawer.

    \note Sheet derives from \c Drawer (the \c Popup family), which does not carry
    an \c Item.TransformOrigin enumeration, so the \c Side members do not collide
    with an inherited enum. \c Side is the only enum declared here, so there is no
    in-file flattening clash either.
*/
C.Drawer {
    id: control

    /*!
        \qmlproperty enumeration Sheet::side
        The window edge the sheet is anchored to and slides in from. Maps to the
        base type's \c edge. Defaults to \c Sheet.RightEdge.

        \value Sheet.TopEdge    Anchored to the top edge; full width, content height.
        \value Sheet.RightEdge  Anchored to the right edge; three-quarter width, full height. (default)
        \value Sheet.BottomEdge Anchored to the bottom edge; full width, content height.
        \value Sheet.LeftEdge   Anchored to the left edge; three-quarter width, full height.
    */
    enum Side { TopEdge, RightEdge, BottomEdge, LeftEdge }

    // ---- Public API ----
    property int side: Sheet.RightEdge          // which edge to pin to / slide in from

    /*!
        \qmlproperty string Sheet::title
        Header title (text-sm, medium weight).
    */
    property string title: ""

    /*!
        \qmlproperty string Sheet::description
        Muted header description shown under the title (text-xs, relaxed leading).
    */
    property string description: ""

    /*!
        \qmlproperty bool Sheet::showCloseButton
        Whether to show the top-right close button (the web \c XIcon). Defaults
        to \c true.
    */
    property bool showCloseButton: true

    /*!
        \qmlproperty list<QtObject> Sheet::content
        Default content slot; laid out in the padded body. Maps to the children
        of \c SheetContent between the header and footer.
    */
    default property alias content: bodyLayout.data

    /*!
        \qmlproperty Item Sheet::footer
        Optional footer item (typically a \c ColumnLayout of buttons), reparented
        into the padded footer region. Maps to \c SheetFooter (\c mt-auto), which
        the body's fill pushes to the bottom.
    */
    property Item footer: null

    // ---- Internal derivations ----
    readonly property bool _horizontal: side === Sheet.LeftEdge || side === Sheet.RightEdge
    // Size against the window overlay, not the parent: a Drawer's parent is the
    // trigger, not the window.
    readonly property var _ov: QQC.Overlay.overlay
    readonly property real _winW: _ov ? _ov.width : 400
    readonly property real _winH: _ov ? _ov.height : 600

    edge: side === Sheet.TopEdge ? Qt.TopEdge
        : side === Sheet.BottomEdge ? Qt.BottomEdge
        : side === Sheet.LeftEdge ? Qt.LeftEdge
        : Qt.RightEdge

    // Sizing: horizontal = min(3/4 window width, 384) x full height;
    // vertical = full width x content height (capped at the window height).
    width: _horizontal ? Math.min(_winW * 0.75, 384) : _winW
    height: _horizontal ? _winH : Math.min(sheetCol.implicitHeight, _winH)

    modal: true
    padding: 0
    dragMargin: 0                           // opened only by a trigger, no edge-drag
    closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

    onFooterChanged: if (footer) footer.parent = footerLayout

    // Modal backdrop: black/80 (.cn-sheet-overlay bg-black/80). backdrop-blur has
    // no matching token, so it is omitted.
    QQC.Overlay.modal: Rectangle { color: Theme.alpha("#000000", 0.8) }

    // Surface: popover base + edge-pinned (no radius) + 1px inner border (border
    // token) + drop shadow (shadow-lg approximation).
    background: Rectangle {
        color: Theme.popover
        radius: 0
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }

        // Inner border: right->left edge, left->right edge, top->bottom edge,
        // bottom->top edge (the edge facing into the viewport).
        Rectangle {
            color: Theme.border
            width: control._horizontal ? 1 : parent.width
            height: control._horizontal ? parent.height : 1
            x: control.side === Sheet.LeftEdge ? parent.width - 1 : 0
            y: control.side === Sheet.TopEdge ? parent.height - 1 : 0
        }
    }

    // Content: header + body (fills, pushing the footer down) + footer, with the
    // close button overlaid in the top-right corner.
    contentItem: Item {
        implicitHeight: sheetCol.implicitHeight

        ColumnLayout {
            id: sheetCol
            anchors.fill: parent
            spacing: 0

            // ==== header: gap-1.5 p-6 ====
            ColumnLayout {
                visible: control.title !== "" || control.description !== ""
                Layout.fillWidth: true
                Layout.margins: Theme.space6      // p-6
                spacing: Theme.space1_5           // gap-1.5
                Text {
                    visible: control.title !== ""
                    Layout.fillWidth: true
                    text: control.title
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm       // text-sm
                    font.weight: Font.Medium
                    wrapMode: Text.Wrap
                }
                Text {
                    visible: control.description !== ""
                    Layout.fillWidth: true
                    text: control.description
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs       // text-xs/relaxed
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }

            // ==== body: default content slot. Fills the remaining space so the
            // footer sits at the bottom (mt-auto). ====
            ColumnLayout {
                id: bodyLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.space6        // mira body px-6
                Layout.rightMargin: Theme.space6
                spacing: Theme.space6                  // body content gap-6
            }

            // ==== footer: gap-2 p-6, mt-auto (pushed down by the body's fill) ====
            ColumnLayout {
                id: footerLayout
                visible: control.footer !== null
                Layout.fillWidth: true
                Layout.margins: Theme.space6           // p-6
                spacing: Theme.space2                  // gap-2
            }
        }

        // ==== top-right close button: absolute top-4 right-4 ====
        IconButton {
            visible: control.showCloseButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Theme.space4
            anchors.rightMargin: Theme.space4
            iconName: "x"
            variant: IconButton.Ghost
            size: IconButton.Small
            onClicked: control.close()
        }
    }

    // Slide in/out: position offset slide + opacity fade (aligned to the web
    // transition duration-200 ease-in-out). Theme has no 200ms token, so durBase
    // (150ms) is used as an approximation.
    enter: Transition {
        NumberAnimation { property: "position"; from: 0; to: 1; duration: Theme.durBase; easing.type: Easing.InOutQuad }
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durBase }
    }
    exit: Transition {
        NumberAnimation { property: "position"; from: 1; to: 0; duration: Theme.durBase; easing.type: Easing.InOutQuad }
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durBase }
    }
}
