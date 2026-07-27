import QtQuick
import QtQuick.Layouts
import Shadcn

// Official empty-avatar-group: overlapping avatar group in the default media slot (-space-x-2 + ring-2 ring-background).
// Note: Avatar enum size Lg = 40 (web size-12 = 48); grayscale unsupported (approximation).
Empty {
    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Default

            Row {
                spacing: -12    // -space-x-2 overlap
                Repeater {
                    model: [
                        { src: "https://github.com/shadcn.png",     fb: "CN" },
                        { src: "https://github.com/maxleiter.png",  fb: "LR" },
                        { src: "https://github.com/evilrabbit.png", fb: "ER" }
                    ]
                    // 2px background-colored outline ring (ring-2 ring-background).
                    Rectangle {
                        width: 44; height: 44; radius: 22
                        color: Theme.background
                        Avatar {
                            anchors.centerIn: parent
                            size: Avatar.Lg
                            source: modelData.src
                            fallback: modelData.fb
                        }
                    }
                }
            }
        }
        EmptyTitle { text: qsTr("No Team Members") }
        EmptyDescription {
            text: qsTr("Invite your team to collaborate on this project.")
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Invite Members")
            size: Button.Sm
            iconName: "plus"
        }
    }
}
