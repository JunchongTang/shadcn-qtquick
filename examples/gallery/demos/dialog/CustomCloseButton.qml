import QtQuick
import QtQuick.Layouts
import Shadcn

// Custom Close Button -- place a custom Close button in the footer (matches dialog-close-button).
// The default top-right close button is kept (consistent with the official example, which also keeps it).
Button {
    text: qsTr("Share")
    variant: Button.Outline
    onClicked: dialog.open()

    Dialog {
        id: dialog
        title: qsTr("Share link")
        description: qsTr("Anyone who has this link will be able to view this.")

        Input {
            width: dialog.availableWidth
            readOnly: true
            text: "https://ui.shadcn.com/docs/installation"
        }

        // footer left-aligned (sm:justify-start): custom Close button
        footerContent: RowLayout {
            Button {
                text: qsTr("Close")
                variant: Button.Outline
                onClicked: dialog.close()
            }
            Item { Layout.fillWidth: true }
        }
    }
}
