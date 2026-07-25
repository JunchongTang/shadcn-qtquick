import QtQuick

PageScaffold {
    description: qsTr("Displays conversational content in a message bubble. Supports variants, alignment, grouping, reactions, and collapsible content.")

    ExampleCard {
        title: qsTr("Bubble")
        source: "qrc:/demos/bubble/Demo.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: qsTr("Variants")
        description: qsTr("Use the variant prop to change the visual treatment, from a strong primary bubble to unframed ghost content.")
        source: "qrc:/demos/bubble/Variants.qml"
        previewMinHeight: 520
    }
    ExampleCard {
        title: qsTr("Alignment")
        description: qsTr("Use align on Bubble to align the bubble to the start or end of the conversation.")
        source: "qrc:/demos/bubble/Alignment.qml"
    }
    ExampleCard {
        title: qsTr("Bubble Group")
        description: qsTr("Use BubbleGroup to group consecutive bubbles from the same sender. Set align on each Bubble.")
        source: "qrc:/demos/bubble/Group.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("Links and Buttons")
        description: qsTr("Turn a bubble into a button by setting interactive on BubbleContent.")
        source: "qrc:/demos/bubble/LinkButton.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("Reactions")
        description: qsTr("Use BubbleReactions for reactions or quick action buttons. Use side and align to position the row.")
        source: "qrc:/demos/bubble/Reactions.qml"
        previewMinHeight: 400
    }
    ExampleCard {
        title: qsTr("Show More / Collapsible")
        description: qsTr("Long bubble content can be composed to allow for a show more or show less interaction.")
        source: "qrc:/demos/bubble/Collapsible.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("Tooltip")
        description: qsTr("Wrap a bubble reaction in a Tooltip to reveal metadata on hover, such as when a message was read.")
        source: "qrc:/demos/bubble/Tooltip.qml"
    }
    ExampleCard {
        title: qsTr("Popover")
        description: qsTr("Pair a bubble with a Popover to surface more information on demand, such as the full error message.")
        source: "qrc:/demos/bubble/Popover.qml"
    }
    ExampleCard {
        title: qsTr("Markdown")
        description: qsTr("Render markdown content inside a bubble, useful for assistant messages.")
        source: "qrc:/demos/bubble/Markdown.qml"
        previewMinHeight: 300
    }
}
