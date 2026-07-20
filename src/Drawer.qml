import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype Drawer
    \inqmlmodule Shadcn
    \inherits Drawer
    \brief A panel that slides in from an edge of the window.

    Drawer wraps the Qt Quick Controls \c Drawer with the shadcn (base-mira) look:
    a rounded popover surface (only the edges facing into the viewport are rounded),
    an optional centered grab \l showHandle {handle}, a header with \l title and
    \l description, a body filled by the default content, and an optional \l footer.

    The slide-in \l side maps to the base type's \c edge. Vertical drawers (top,
    bottom) span the full width and grow with content up to the viewport height
    minus 6rem; horizontal drawers (left, right) span the full height at a fixed
    24rem width.

    The file name shadows the base type, so it is imported aliased (\c {as C}) and
    the root is \c C.Drawer.
*/
C.Drawer {
    id: control

    /*!
        \qmlproperty string Drawer::side
        Edge the drawer slides in from: \c "bottom" (default), \c "top", \c "left"
        or \c "right". Maps to the web swipe direction.
    */
    property string side: "bottom"

    /*!
        \qmlproperty string Drawer::title
        Header title. Centered for vertical drawers, left-aligned for horizontal ones.
    */
    property string title: ""

    /*!
        \qmlproperty string Drawer::description
        Muted header description shown under the title.
    */
    property string description: ""

    /*!
        \qmlproperty bool Drawer::showHandle
        Whether to show the centered grab handle at the leading edge. Only applies
        to vertical drawers. Defaults to \c true.
    */
    property bool showHandle: true

    /*!
        \qmlproperty list<QtObject> Drawer::content
        Default content slot; laid out in the padded body (p-4).
    */
    default property alias content: bodyContainer.data

    /*!
        \qmlproperty Item Drawer::footer
        Optional footer item (typically a \c ColumnLayout of buttons), reparented
        into the padded footer region and stretched to full width.
    */
    property Item footer: null

    readonly property bool _vertical: side === "bottom" || side === "top"
    readonly property int _viewportW: parent ? parent.width : 400
    readonly property int _viewportH: parent ? parent.height : 600

    edge: side === "top" ? Qt.TopEdge
        : side === "left" ? Qt.LeftEdge
        : side === "right" ? Qt.RightEdge
        : Qt.BottomEdge

    modal: true
    padding: 0

    // Vertical: full width, height follows content capped at viewport - 6rem.
    // Horizontal: full height, fixed 24rem width (clamped to the viewport).
    width: _vertical ? _viewportW : Math.min(384, _viewportW)
    height: _vertical ? Math.min(layoutRoot.implicitHeight, _viewportH - 96) : _viewportH

    // Modal backdrop: black/80 (.cn-drawer-overlay bg-black/80).
    QQC.Overlay.modal: Rectangle { color: Theme.alpha("#000000", 0.8) }

    // Surface: popover base + ring-1 ring-foreground/10 + shadow; only the corners
    // facing into the viewport are rounded (rounded-xl).
    background: Rectangle {
        color: Theme.popover
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        topLeftRadius: (control.side === "bottom" || control.side === "right") ? Theme.radiusXl : 0
        topRightRadius: (control.side === "bottom" || control.side === "left") ? Theme.radiusXl : 0
        bottomLeftRadius: (control.side === "top" || control.side === "right") ? Theme.radiusXl : 0
        bottomRightRadius: (control.side === "top" || control.side === "left") ? Theme.radiusXl : 0
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }
    }

    // handle + header + body + footer stacked vertically.
    contentItem: ColumnLayout {
        id: layoutRoot
        spacing: 0

        // Grab handle: muted h-1.5 w-[100px] rounded-full, mt-4, centered. Vertical only.
        Rectangle {
            visible: control.showHandle && control._vertical
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Theme.space4        // mt-4
            implicitWidth: 100                    // w-[100px]
            implicitHeight: 6                     // h-1.5
            radius: height / 2                    // rounded-full
            color: Theme.muted
        }

        // Header: title + description (p-4 pb-0, gap-1).
        ColumnLayout {
            visible: control.title !== "" || control.description !== ""
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space4
            Layout.rightMargin: Theme.space4
            Layout.topMargin: Theme.space4
            spacing: Theme.space1                 // gap-1

            Text {
                visible: control.title !== ""
                Layout.fillWidth: true
                text: control.title
                color: Theme.foreground
                font.pixelSize: Theme.textSm      // text-sm = 14
                font.weight: Font.Medium
                wrapMode: Text.Wrap
                horizontalAlignment: control._vertical ? Text.AlignHCenter : Text.AlignLeft
            }
            Text {
                visible: control.description !== ""
                Layout.fillWidth: true
                text: control.description
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs      // text-xs = 12
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                horizontalAlignment: control._vertical ? Text.AlignHCenter : Text.AlignLeft
            }
        }

        // Body: default content (p-4). Horizontal drawers fill remaining height.
        ColumnLayout {
            id: bodyContainer
            Layout.fillWidth: true
            Layout.fillHeight: !control._vertical
            Layout.margins: Theme.space4          // p-4
            spacing: Theme.space2
        }

        // Footer slot: consumer-injected footer item (p-4 pt-0).
        Item {
            id: footerHolder
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space4
            Layout.rightMargin: Theme.space4
            Layout.bottomMargin: Theme.space4     // p-4 (pt-0)
            visible: control.footer !== null
            implicitHeight: control.footer ? control.footer.implicitHeight : 0
        }
    }

    onFooterChanged: {
        if (footer) {
            footer.parent = footerHolder
            footer.x = 0
            footer.width = Qt.binding(function () { return footerHolder.width })
        }
    }
}
