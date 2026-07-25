import QtQuick

PageScaffold {
    description: "Styles for headings, paragraphs, lists, etc. We do not ship any typography "
        + "styles by default — this page shows how to compose text with the Theme tokens."

    ExampleCard {
        title: "Demo"
        source: "qrc:/demos/typography/Demo.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: "h1"
        source: "qrc:/demos/typography/H1.qml"
    }
    ExampleCard {
        title: "h2"
        source: "qrc:/demos/typography/H2.qml"
    }
    ExampleCard {
        title: "h3"
        source: "qrc:/demos/typography/H3.qml"
    }
    ExampleCard {
        title: "h4"
        source: "qrc:/demos/typography/H4.qml"
    }
    ExampleCard {
        title: "p"
        source: "qrc:/demos/typography/P.qml"
    }
    ExampleCard {
        title: "blockquote"
        source: "qrc:/demos/typography/Blockquote.qml"
    }
    ExampleCard {
        title: "table"
        source: "qrc:/demos/typography/Table.qml"
    }
    ExampleCard {
        title: "list"
        source: "qrc:/demos/typography/List.qml"
    }
    ExampleCard {
        title: "Inline code"
        source: "qrc:/demos/typography/InlineCode.qml"
    }
    ExampleCard {
        title: "Lead"
        source: "qrc:/demos/typography/Lead.qml"
    }
    ExampleCard {
        title: "Large"
        source: "qrc:/demos/typography/Large.qml"
    }
    ExampleCard {
        title: "Small"
        source: "qrc:/demos/typography/Small.qml"
    }
    ExampleCard {
        title: "Muted"
        source: "qrc:/demos/typography/Muted.qml"
    }
}
