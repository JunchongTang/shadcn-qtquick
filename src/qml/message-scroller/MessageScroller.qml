import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype MessageScroller
    \inqmlmodule Shadcn
    \inherits Item
    \brief A scroll container for a chat transcript.

    MessageScroller is the QML port of shadcn's base-mira message-scroller. An
    Item shell wraps a Shadcn \l ScrollView (thin scrollbar) that lays out its
    default children as a vertical message column (\c gap-6), plus a floating
    "jump to latest" button that surfaces when the reader has scrolled away from
    the bottom.

    Its one behavioral guarantee mirrors the reference's \c autoScroll: while the
    reader is already at the bottom, the viewport pins to the bottom as content
    grows (a message streams in, a new turn arrives); the moment the reader
    scrolls up, auto-follow backs off and their position is preserved.

    Default children are the message rows (typically \l Message), stacked in
    declaration order. Place a MessageScroller inside a height-constrained parent.

    \qml
    MessageScroller {
        anchors.fill: parent
        Message { }
        Message { }
    }
    \endqml

    This base port intentionally omits the reference's advanced infrastructure:
    full streaming/live-edge semantics beyond "pin when already at bottom",
    new-turn anchoring (\c scrollAnchor / previous-item peek), position
    preservation when prepending history (\c preserveScrollOnPrepend),
    last-anchor restoration for reopened conversations, virtualization,
    command hooks (\c scrollToMessage) and visibility tracking, and enter
    animations / reduced-motion.

    \sa Message, ScrollView
*/
Item {
    id: root

    /*!
        \qmlproperty list<QtObject> MessageScroller::messages
        \qmldefault
        The message rows, laid out top-to-bottom in the scrollable column.
        Assigned via the component's default child list.
    */
    default property alias messages: col.data

    /*!
        \qmlproperty bool MessageScroller::autoScroll
        When \c true (default), the viewport follows the bottom edge as content
        grows, but only while the reader is already at the bottom. Set to
        \c false to leave the scroll position under the reader's control.
    */
    property bool autoScroll: true

    /*!
        \qmlproperty real MessageScroller::messageSpacing
        Vertical gap between message rows. Defaults to \c Theme.space6 (gap-6).
    */
    property real messageSpacing: Theme.space6

    /*!
        \qmlproperty real MessageScroller::contentPadding
        Inset around the message column. Defaults to \c Theme.space4 (p-4).
    */
    property real contentPadding: Theme.space4

    // Internal: whether the viewport is currently pinned to (near) the bottom.
    property bool _atBottom: true
    // Internal: the ScrollView's backing Flickable, source of scroll geometry.
    readonly property var _flick: view.contentItem

    implicitWidth: 360
    implicitHeight: 420

    /*!
        \qmlmethod void MessageScroller::scrollToEnd()
        Scrolls the viewport to the bottom so the latest message is visible.
    */
    function scrollToEnd() {
        if (_flick)
            _flick.contentY = Math.max(0, _flick.contentHeight - _flick.height)
    }

    // Recompute _atBottom from current scroll geometry. The 8px slack is the
    // reference's scroll-edge threshold; when content fits, the target is
    // negative so contentY (0) counts as "at bottom".
    function _refreshAtBottom() {
        if (_flick)
            _atBottom = _flick.contentY >= _flick.contentHeight - _flick.height - 8
    }

    ScrollView {
        id: view
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth

        // Content wrapper: supplies a definite contentHeight (including the
        // surrounding padding) so the viewport never scrolls horizontally.
        Item {
            id: contentWrap
            implicitWidth: view.availableWidth
            implicitHeight: col.implicitHeight + root.contentPadding * 2

            ColumnLayout {
                id: col
                x: root.contentPadding
                y: root.contentPadding
                width: contentWrap.width - root.contentPadding * 2
                spacing: root.messageSpacing
            }
        }
    }

    Connections {
        target: root._flick
        ignoreUnknownSignals: true
        function onContentYChanged() { root._refreshAtBottom() }
        function onHeightChanged() { root._refreshAtBottom() }
        function onContentHeightChanged() {
            // While auto-following, keep _atBottom true and let the queued
            // scrollToEnd (via its contentY change) reconfirm it. Refreshing
            // here against the stale contentY would flip _atBottom to false for
            // one frame and flash the jump button. Otherwise, refresh so the
            // button reflects the new geometry.
            if (root.autoScroll && root._atBottom)
                Qt.callLater(root.scrollToEnd)
            else
                root._refreshAtBottom()
        }
    }
    Component.onCompleted: Qt.callLater(scrollToEnd)

    // ==== Jump to latest: surfaces when not at the bottom; pinned to the
    // viewport (does not scroll with content). ====
    Rectangle {
        id: jump
        width: 32
        height: 32
        radius: Theme.radiusFull
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        color: jHover.hovered ? Theme.muted : Theme.background
        border.width: 1
        border.color: Theme.border
        opacity: root._atBottom ? 0 : 1
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: Theme.durBase } }
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        LucideIcon {
            anchors.centerIn: parent
            name: "arrow-down"
            size: 16
            color: Theme.foreground
        }
        HoverHandler { id: jHover }
        TapHandler { onTapped: root.scrollToEnd() }
    }
}
