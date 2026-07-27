import QtQuick
import QtQuick.Layouts
import Shadcn

// Card Edge to Edge —— mirrors official card-edge-to-edge: CardContent uses edgeToEdge
// (= -mx-(--card-spacing)) so the inner muted scroll area spans the card's left/right edges,
// while adding px = cardSpacing back inside to align text with the card inset; Layout.bottomMargin = -cardSpacing
// (= -mb-(--card-spacing)) removes the block gap to the footer.
Card {
    id: card
    width: 360

    // Top-level inline component: shared paragraph style (text-sm/relaxed + px-(--card-spacing)).
    component Para : Text {
        Layout.fillWidth: true
        Layout.leftMargin: card.cardSpacing
        Layout.rightMargin: card.cardSpacing
        color: Theme.foreground
        font.pixelSize: Theme.textSm
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }

    CardHeader {
        CardTitle { text: qsTr("Terms of Service") }
        CardDescription { text: qsTr("Review the terms before accepting the agreement.") }
    }

    CardContent {
        edgeToEdge: true
        Layout.bottomMargin: -card.cardSpacing

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 190          // max-h-48 ≈ 192, overflow scrolls vertically
            color: Theme.alpha(Theme.muted, 0.5) // bg-muted/50

            // border-t
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Theme.border
            }

            ScrollView {
                id: sv
                anchors.fill: parent
                anchors.topMargin: 1             // clear the top border
                clip: true
                contentWidth: availableWidth     // vertical scroll only

                ColumnLayout {
                    width: sv.availableWidth
                    spacing: 16                  // space-y-4

                    Item { Layout.fillWidth: true; implicitHeight: 16 } // py-4 top
                    Para { text: qsTr("These terms govern your use of the workspace, including access to shared documents, project files, and collaboration tools.") }
                    Para { text: qsTr("You are responsible for the content you upload and for ensuring that your team has the appropriate permissions to view or edit it.") }
                    Para { text: qsTr("We may update features or limits as the service evolves. When those changes materially affect your workflow, we will notify your workspace administrators.") }
                    Para { text: qsTr("By continuing, you agree to keep your account credentials secure and to follow your organization's acceptable use policies.") }
                    Item { Layout.fillWidth: true; implicitHeight: 16 } // py-4 bottom
                }
            }
        }
    }

    CardFooter {
        Item { Layout.fillWidth: true }          // justify-end
        Button { text: qsTr("Decline"); variant: Button.Outline }
        Button { text: qsTr("Accept") }
    }
}
