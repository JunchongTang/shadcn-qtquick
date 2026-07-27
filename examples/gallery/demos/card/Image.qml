import QtQuick
import QtQuick.Layouts
import Shadcn

// Card Image —— mirrors official card-image: a flush cover image at the card top (aspect-video, rounded top).
// The image is the card's first child → drop the top padding (has-[>img:first-child]:pt-0), and use
// -cardSpacing negative margins on top/left/right to span the card edges; the two top corners match the card radius (*:[img:first-child]:rounded-t-lg).
Card {
    id: card
    width: 340

    // ==== Top cover (Rectangle placeholder color + dark overlay, equivalent to <img> + bg-black/35) ====
    Item {
        Layout.fillWidth: true
        Layout.leftMargin: -card.cardSpacing
        Layout.rightMargin: -card.cardSpacing
        Layout.topMargin: -card.cardSpacing
        Layout.preferredHeight: width * 9 / 16   // aspect-video

        Rectangle {
            anchors.fill: parent
            topLeftRadius: Theme.radiusLg
            topRightRadius: Theme.radiusLg
            color: Theme.secondary               // placeholder cover color
        }
        // Dark overlay (bg-black/35)
        Rectangle {
            anchors.fill: parent
            topLeftRadius: Theme.radiusLg
            topRightRadius: Theme.radiusLg
            color: Theme.alpha("#000000", 0.35)
        }
        Text {
            anchors.centerIn: parent
            text: qsTr("Event cover")
            color: Theme.alpha("#ffffff", 0.85)
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
    }

    CardHeader {
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.space2
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space1
                CardTitle { text: qsTr("Design systems meetup") }
                CardDescription { text: qsTr("A practical talk on component APIs, accessibility, and shipping faster.") }
            }
            Badge { text: qsTr("Featured"); variant: Badge.Secondary; Layout.alignment: Qt.AlignTop }
        }
    }

    CardFooter {
        Button { Layout.fillWidth: true; text: qsTr("View Event") }
    }
}
