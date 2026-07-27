import QtQuick

// Message Scroller detail page. Basic version: scrollable chat container + auto scroll-to-bottom + jump to latest + typing visual.
// Honestly skipped (all unimplemented): streaming follow (follow live edge), new-turn anchoring (scrollAnchor + top anchor + previous-message peek),
// load-history position preservation (preserveScrollOnPrepend), last-anchor positioning when opening an existing session, virtualization / content-visibility,
// command palette / scrollToMessage / visibility-tracking hooks, entrance animation.
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
