import QtQuick

// Message Scroller 详情页。基础版:可滚动聊天容器 + 自动贴底 + 跳至最新 + typing 视觉。
// 诚实跳过(均未实现):流式跟随(follow live edge)、新回合锚定(scrollAnchor + 顶部锚点 + 上一条 peek)、
// 加载历史位置保持(preserveScrollOnPrepend)、打开已存会话 last-anchor 定位、虚拟化 / content-visibility、
// 命令面板 / scrollToMessage / 可见性追踪 hooks、进场动画。
PageScaffold {
    description: qsTr("A chat scroll container: a vertical message column with a thin scrollbar, auto scroll-to-bottom, and a jump-to-latest control. Basic QML port — turn anchoring, streaming follow, load-history preservation, virtualization, and scroll commands are NOT implemented.")

    ExampleCard {
        title: qsTr("Message Scroller")
        description: qsTr("A height-constrained chat frame that sticks to the bottom as messages arrive.")
        source: "qrc:/demos/message-scroller/Demo.qml"
        previewMinHeight: 520
    }
    ExampleCard {
        title: qsTr("Scrollable")
        description: qsTr("A longer transcript that overflows the viewport. Scroll up to reveal the jump-to-latest button.")
        source: "qrc:/demos/message-scroller/Scrollable.qml"
        previewMinHeight: 520
    }
    ExampleCard {
        title: qsTr("Typing Indicator")
        description: qsTr("A typing row at the end of the transcript. Streaming token-by-token follow is not implemented.")
        source: "qrc:/demos/message-scroller/Typing.qml"
        previewMinHeight: 420
    }
}
