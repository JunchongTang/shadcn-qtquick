import QtQuick

PageScaffold {
    description: "Displays conversational content in a message bubble. Supports variants, alignment, grouping, reactions, and collapsible content."

    ExampleCard {
        title: "Bubble"
        source: "qrc:/demos/bubble/Demo.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: "Variants"
        description: "Use the variant prop to change the visual treatment, from a strong primary bubble to unframed ghost content."
        source: "qrc:/demos/bubble/Variants.qml"
        previewMinHeight: 520
    }
    ExampleCard {
        title: "Alignment"
        description: "Use align on Bubble to align the bubble to the start or end of the conversation."
        source: "qrc:/demos/bubble/Alignment.qml"
    }
    ExampleCard {
        title: "Bubble Group"
        description: "Use BubbleGroup to group consecutive bubbles from the same sender. Set align on each Bubble."
        source: "qrc:/demos/bubble/Group.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: "Links and Buttons"
        description: "Turn a bubble into a button by setting interactive on BubbleContent."
        source: "qrc:/demos/bubble/LinkButton.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: "Reactions"
        description: "Use BubbleReactions for reactions or quick action buttons. Use side and align to position the row."
        source: "qrc:/demos/bubble/Reactions.qml"
        previewMinHeight: 400
    }
    ExampleCard {
        title: "Show More / Collapsible"
        description: "Long bubble content can be composed to allow for a show more or show less interaction."
        source: "qrc:/demos/bubble/Collapsible.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: "Tooltip"
        description: "Wrap a bubble reaction in a Tooltip to reveal metadata on hover, such as when a message was read."
        source: "qrc:/demos/bubble/Tooltip.qml"
    }
    ExampleCard {
        title: "Popover"
        description: "Pair a bubble with a Popover to surface more information on demand, such as the full error message."
        source: "qrc:/demos/bubble/Popover.qml"
    }
    ExampleCard {
        title: "Markdown"
        description: "Render markdown content inside a bubble, useful for assistant messages."
        source: "qrc:/demos/bubble/Markdown.qml"
        previewMinHeight: 300
    }
}
