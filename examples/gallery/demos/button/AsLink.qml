import QtQuick
import QtQuick.Layouts
import Shadcn

// As Link: make a link look like a button / make a button act as a link.
// Officially buttonVariants({variant:"secondary",size:"sm"}) is applied on an <a>;
// QML has no native anchor, so here we use a Link variant and a secondary/sm button + onClicked to open an external link.
RowLayout {
    spacing: 8
    Button {
        variant: Button.Link
        text: qsTr("Login")
        onClicked: Qt.openUrlExternally("https://ui.shadcn.com/docs/components/button")
    }
    Button {
        variant: Button.Secondary
        size: Button.Sm
        text: qsTr("Login")
        onClicked: Qt.openUrlExternally("https://ui.shadcn.com/docs/components/button")
    }
}
