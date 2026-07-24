import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C

/*!
    \qmltype Attachment
    \inqmlmodule Shadcn
    \inherits Item
    \brief A file/image attachment card with media, metadata and actions.

    Attachment is the base-mira \c .cn-attachment card: a leading media slot
    (\l AttachmentMedia — thumbnail or file-type icon), a content column
    (\l AttachmentContent holding \l AttachmentName and \l AttachmentSize), and
    an optional trailing actions row (\l AttachmentActions of \l AttachmentAction).
    Its outline reflects the upload lifecycle (\l uploadState): dashed while idle,
    a destructive border on error, solid otherwise.

    Children are declared in the default slot and routed to the correct layout on
    completion via each child's \c attachSlot marker. Lay several cards out in a
    scrollable row with \l AttachmentGroup.

    The web root prop is named \c state, but \c Item already has a built-in string
    \c state, so it is renamed \l uploadState here (same semantics). Drag-drop and
    real upload progress are approximated with static states.

    \sa AttachmentGroup, AttachmentMedia, AttachmentContent, AttachmentActions
*/
Item {
    id: control

    /*!
        \qmlproperty enumeration Attachment::uploadState
        Upload lifecycle (the web \c state); drives the outline style and the
        title shimmer.
        \value Attachment.Idle Empty drop target; dashed border.
        \value Attachment.Uploading Transfer in progress; title shimmers.
        \value Attachment.Processing Server-side processing; title shimmers.
        \value Attachment.Error Failure; destructive border and description.
        \value Attachment.Done Completed (default).
    */
    enum State { Idle, Uploading, Processing, Error, Done }

    /*!
        \qmlproperty enumeration Attachment::size
        Compact size scale controlling padding, gap, radius and media box.
        \value Attachment.Default px-2 py-1.5, gap-2, rounded-lg, 40px media.
        \value Attachment.Sm px-1.5 py-1, gap-2.5, 32px media.
        \value Attachment.Xs px-1.5 py-1, gap-1.5, rounded-md, 28px media.
    */
    enum Size { Default, Sm, Xs }

    /*!
        \qmlproperty enumeration Attachment::orientation
        Card layout direction.
        \value Attachment.Horizontal media | content | actions (min-w-40).
        \value Attachment.Vertical media over content; actions float top-right.
    */
    enum Orientation { Horizontal, Vertical }

    // All enum member names above are unique, so QML's flattening of enum values
    // into the type scope introduces no collisions (see #028).

    /*! \qmlproperty enumeration Attachment::uploadState \brief Upload lifecycle; see \l State. Defaults to \c Attachment.Done. */
    property int uploadState: Attachment.Done
    /*! \qmlproperty enumeration Attachment::size \brief Compact size scale; see \l Size. Defaults to \c Attachment.Default. */
    property int size: Attachment.Default
    /*! \qmlproperty enumeration Attachment::orientation \brief Layout direction; see \l Orientation. Defaults to \c Attachment.Horizontal. */
    property int orientation: Attachment.Horizontal

    /*!
        \qmlsignal Attachment::triggered()
        Emitted when the full-card \l AttachmentTrigger overlay is activated
        (click or Enter).
    */
    signal triggered()

    /*!
        \qmlproperty list<QtObject> Attachment::content
        Default slot. Children are collected in a hidden sink and routed to the
        layout on completion by their \c attachSlot marker.
    */
    default property alias content: sink.data

    readonly property bool _horizontal: orientation === Attachment.Horizontal
    readonly property bool _idle: uploadState === Attachment.Idle
    readonly property bool _error: uploadState === Attachment.Error

    // Padding / gap / radius (mirrors .cn-attachment-size-*).
    // default: px-2 py-1.5 gap-2; sm/xs: px-1.5 py-1; sm gap-2.5; xs gap-1.5 rounded-md.
    readonly property real _padH: size === Attachment.Default ? Theme.space2 : Theme.space1_5
    readonly property real _padV: size === Attachment.Default ? Theme.space1_5 : Theme.space1
    readonly property real _gap: size === Attachment.Default ? Theme.space2
                               : size === Attachment.Sm ? Theme.space2_5 : Theme.space1_5
    readonly property real _radius: size === Attachment.Xs ? Theme.radiusMd : Theme.radiusLg

    // Vertical: fixed narrow card w-24 (96) / w-30 (120) with content;
    // horizontal: min-w-40 (160). Set during _route().
    property bool _hasContent: false
    property bool _hasTrigger: false

    implicitWidth: _horizontal
        ? Math.max(160, rowFlow.implicitWidth + _padH * 2)
        : (_hasContent ? 120 : 96)
    implicitHeight: _horizontal
        ? rowFlow.implicitHeight + _padV * 2
        : colFlow.implicitHeight + _padV * 2

    activeFocusOnTab: false

    // Hidden collection area for the default slot.
    Item { id: sink; visible: false; width: 0; height: 0 }

    // ==== Background + border ====
    // bg-card; with a trigger and hovered -> bg-muted/50. idle uses a dashed
    // border, error uses destructive/30.
    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: control._radius
        color: (control._hasTrigger && rootHover.hovered)
               ? Theme.alpha(Theme.muted, 0.5) : Theme.card
        border.width: control._idle ? 0 : 1
        border.color: control._error ? Theme.alpha(Theme.destructive, 0.30) : Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durBase } }
    }

    // Idle dashed border (Rectangle has no dash support; a Canvas approximates
    // border-dashed).
    Canvas {
        id: dashBorder
        anchors.fill: parent
        visible: control._idle
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var r = control._radius, w = width - 1, h = height - 1, x = 0.5, y = 0.5
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            ctx.setLineDash([4, 4])
            ctx.beginPath()
            ctx.moveTo(x + r, y)
            ctx.arcTo(x + w, y, x + w, y + h, r)
            ctx.arcTo(x + w, y + h, x, y + h, r)
            ctx.arcTo(x, y + h, x, y, r)
            ctx.arcTo(x, y, x + w, y, r)
            ctx.closePath()
            ctx.stroke()
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        // Repaint on theme change (border color varies with light/dark).
        readonly property color _strokeColor: Theme.border
        on_StrokeColorChanged: requestPaint()
    }

    // ==== Full-card trigger overlay (below content so actions stay clickable) ====
    // Text/Image/Rectangle in the content do not accept the mouse, so events fall
    // through to this button; actions are real buttons and intercept on their own.
    C.Button {
        id: triggerButton
        anchors.fill: parent
        visible: control._hasTrigger
        enabled: control._hasTrigger
        activeFocusOnTab: control._hasTrigger
        hoverEnabled: true
        background: Item {}
        contentItem: Item {}
        onClicked: {
            if (control._trigger)
                control._trigger.clicked()
            control.triggered()
        }
    }
    property var _trigger: null
    HoverHandler {
        id: rootHover
        enabled: control._hasTrigger
        cursorShape: Qt.PointingHandCursor
    }

    // ==== Horizontal layout: media | content (stretch) | actions ====
    RowLayout {
        id: rowFlow
        visible: control._horizontal
        anchors.fill: parent
        anchors.leftMargin: control._padH
        anchors.rightMargin: control._padH
        anchors.topMargin: control._padV
        anchors.bottomMargin: control._padV
        spacing: control._gap
    }

    // ==== Vertical layout: media (full-width square) / content; actions float top-right ====
    ColumnLayout {
        id: colFlow
        visible: !control._horizontal
        anchors.fill: parent
        anchors.leftMargin: control._padH
        anchors.rightMargin: control._padH
        anchors.topMargin: control._padV
        anchors.bottomMargin: control._padV
        spacing: control._gap
    }

    // 1px focus ring (approximates focus-within:ring-1 ring-ring/30 when the
    // trigger overlay has focus).
    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        radius: control._radius + 1
        color: "transparent"
        border.width: 1
        border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
        visible: triggerButton.activeFocus
        z: 5
    }

    Component.onCompleted: _route()

    function _route() {
        var kids = []
        for (var i = 0; i < sink.children.length; i++)
            kids.push(sink.children[i])

        var media = null, contents = [], actions = null
        for (var j = 0; j < kids.length; j++) {
            var c = kids[j]
            if (!c || c.attachSlot === undefined)
                continue
            switch (c.attachSlot) {
            case "attachment-media": media = c; break
            case "attachment-content": contents.push(c); break
            case "attachment-actions": actions = c; break
            case "attachment-trigger":
                control._trigger = c
                control._hasTrigger = true
                break
            }
        }
        _hasContent = contents.length > 0

        // Inject host state into the slotted children.
        if (media) {
            if (media.hostSize !== undefined) media.hostSize = Qt.binding(function(){ return control.size })
            if (media.hostOrientation !== undefined) media.hostOrientation = Qt.binding(function(){ return control.orientation })
            if (media.hostState !== undefined) media.hostState = Qt.binding(function(){ return control.uploadState })
        }
        for (var k = 0; k < contents.length; k++) {
            var ct = contents[k]
            if (ct.hostSize !== undefined) ct.hostSize = Qt.binding(function(){ return control.size })
            if (ct.hostState !== undefined) ct.hostState = Qt.binding(function(){ return control.uploadState })
        }

        var flow = control._horizontal ? rowFlow : colFlow

        if (media) {
            media.parent = flow
            if (control._horizontal) {
                media.Layout.alignment = Qt.AlignVCenter
            } else {
                media.Layout.fillWidth = true
                media.Layout.preferredHeight = Qt.binding(function(){ return media.width })
            }
        }
        for (var m = 0; m < contents.length; m++) {
            var cc = contents[m]
            cc.parent = flow
            cc.Layout.fillWidth = true
            // Second and later content columns do not stretch (flex-none).
            if (m > 0 && cc.contentFill !== undefined) {
                cc.contentFill = false
                cc.Layout.fillWidth = false
            }
        }
        if (actions) {
            if (control._horizontal) {
                actions.parent = flow
                actions.Layout.alignment = Qt.AlignVCenter
                if (actions.hostOrientation !== undefined)
                    actions.hostOrientation = Attachment.Horizontal
            } else {
                // Vertical: float top-right (top-3 right-3), z-20.
                actions.parent = control
                actions.z = 20
                actions.anchors.top = control.top
                actions.anchors.right = control.right
                actions.anchors.topMargin = Theme.space3
                actions.anchors.rightMargin = Theme.space3
                if (actions.hostOrientation !== undefined)
                    actions.hostOrientation = Attachment.Vertical
            }
        }
    }
}
