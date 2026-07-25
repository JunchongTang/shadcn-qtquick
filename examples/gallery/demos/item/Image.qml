import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 420

    ItemGroup {
        Layout.fillWidth: true

        Repeater {
            model: [
                { title: qsTr("Midnight City Lights"), album: "Electric Nights", artist: "Neon Dreams",     duration: "3:45", seed: "11" },
                { title: qsTr("Coffee Shop Talk"),     album: "Urban Stories",   artist: "The Morning Brew", duration: "4:05", seed: "22" },
                { title: qsTr("Digital Rain"),         album: "Binary Beats",    artist: "Cyber Symphony",   duration: "3:30", seed: "33" }
            ]
            delegate: ShadItem {
                required property var modelData
                Layout.fillWidth: true
                variant: ShadItem.Outline
                asLink: true

                ItemMedia {
                    variant: ItemMedia.Image
                    source: "https://picsum.photos/seed/" + modelData.seed + "/64"
                }
                ItemContent {
                    ItemTitle {
                        text: modelData.title + " — " + modelData.album
                    }
                    ItemDescription { text: modelData.artist }
                }
                ItemContent {
                    ItemDescription {
                        text: modelData.duration
                        maximumLineCount: 1
                    }
                }
            }
        }
    }
}
