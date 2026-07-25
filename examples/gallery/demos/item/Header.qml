import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 560

    RowLayout {
        Layout.fillWidth: true
        spacing: 16

        Repeater {
            model: [
                { name: "v0-1.5-sm",   description: qsTr("Everyday tasks and UI generation."), seed: "101" },
                { name: "v0-1.5-lg",   description: qsTr("Advanced thinking or reasoning."),   seed: "102" },
                { name: "v0-2.0-mini", description: qsTr("Open Source model for everyone."),   seed: "103" }
            ]
            delegate: ShadItem {
                required property var modelData
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                variant: ShadItem.Outline

                ItemHeader {
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width   // aspect-square
                        radius: Theme.radiusSm
                        color: Theme.muted
                        clip: true
                        Image {
                            anchors.fill: parent
                            source: "https://picsum.photos/seed/" + modelData.seed + "/240"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
                ItemContent {
                    ItemTitle { text: modelData.name }
                    ItemDescription { text: modelData.description }
                }
            }
        }
    }
}
