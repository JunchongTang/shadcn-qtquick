import QtQuick

PageScaffold {
    description: qsTr("Styles for headings, paragraphs, lists, etc. We do not ship any typography ")
        + "styles by default — this page shows how to compose text with the Theme tokens."

    ExampleCard {
        title: qsTr("Demo")
        source: "qrc:/demos/typography/Demo.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("h1")
        source: "qrc:/demos/typography/H1.qml"
    }
    ExampleCard {
        title: qsTr("h2")
        source: "qrc:/demos/typography/H2.qml"
    }
    ExampleCard {
        title: qsTr("h3")
        source: "qrc:/demos/typography/H3.qml"
    }
    ExampleCard {
        title: qsTr("h4")
        source: "qrc:/demos/typography/H4.qml"
    }
    ExampleCard {
        title: qsTr("p")
        source: "qrc:/demos/typography/P.qml"
    }
    ExampleCard {
        title: qsTr("blockquote")
        source: "qrc:/demos/typography/Blockquote.qml"
    }
    ExampleCard {
        title: qsTr("table")
        source: "qrc:/demos/typography/Table.qml"
    }
    ExampleCard {
        title: qsTr("list")
        source: "qrc:/demos/typography/List.qml"
    }
    ExampleCard {
        title: qsTr("Inline code")
        source: "qrc:/demos/typography/InlineCode.qml"
    }
    ExampleCard {
        title: qsTr("Lead")
        source: "qrc:/demos/typography/Lead.qml"
    }
    ExampleCard {
        title: qsTr("Large")
        source: "qrc:/demos/typography/Large.qml"
    }
    ExampleCard {
        title: qsTr("Small")
        source: "qrc:/demos/typography/Small.qml"
    }
    ExampleCard {
        title: qsTr("Muted")
        source: "qrc:/demos/typography/Muted.qml"
    }
}
