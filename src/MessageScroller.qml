import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn MessageScroller(base-mira · 基础版)—— 聊天转录滚动容器。
// 结构:Item 外壳包裹 Shadcn ScrollView(细滚动条)+ 悬浮「跳至最新」按钮。
// 纵向消息列(gap-6),内容增长且已在底部时自动贴底;用户上滑后释放,不再强制下拉。
// 默认子项即为消息行(通常是 Message),按声明顺序纵向排列。
//
// 用法:置于「高度受限」的容器内(fill 父)。
//   MessageScroller { anchors.fill: parent
//       Message { … }
//       Message { … }
//   }
//
// 未实现(高级基建,基础版诚实跳过,均不做):
//   · 流式跟随(follow live edge)与 autoScroll 的完整语义(仅做「已在底部则贴底」)
//   · 新回合锚定(scrollAnchor / 顶部锚点 + 上一条 peek)
//   · 加载历史时的位置保持(preserveScrollOnPrepend,不跳动)
//   · 打开已存会话的 last-anchor 定位
//   · 虚拟化 / content-visibility 性能优化
//   · 命令面板 / scrollToMessage / 可见性追踪等 hooks
//   · 进场动画、reduced-motion
Item {
    id: root

    // 默认子项 → 消息列。
    default property alias messages: col.data

    property bool autoScroll: true
    property real messageSpacing: Theme.space6      // cn-message-scroller-content gap-6
    property real contentPadding: Theme.space4      // 列表四周留白(默认 p-4)

    property bool _atBottom: true
    readonly property var _flick: view.contentItem

    implicitWidth: 360
    implicitHeight: 420

    function scrollToEnd() {
        if (_flick)
            _flick.contentY = Math.max(0, _flick.contentHeight - _flick.height)
    }
    function _refreshAtBottom() {
        if (_flick)
            _atBottom = _flick.contentY >= _flick.contentHeight - _flick.height - 8
    }

    ScrollView {
        id: view
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth

        // 内容包裹:提供确定的 contentHeight(含四周留白),避免横向滚动。
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
            if (root.autoScroll && root._atBottom)
                Qt.callLater(root.scrollToEnd)
            root._refreshAtBottom()
        }
    }
    Component.onCompleted: Qt.callLater(scrollToEnd)

    // ==== 跳至最新(未在底部时浮现,不随内容滚动)====
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
