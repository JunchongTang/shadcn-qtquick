import QtQuick
import QtQuick.Layouts
import Shadcn

// Bubble with Tooltip: place an icon button in the reaction row; hovering shows metadata (read time).
// Mirrors official bubble-tooltip.
ColumnLayout {
    width: 360
    spacing: 16

    Bubble {
        variant: Bubble.Secondary
        BubbleContent { text: qsTr("Did you remove the stale route?") }
    }

    Bubble {
        align: Bubble.End
        BubbleContent { text: qsTr("Yes, removed it from the registry.") }
        BubbleReactions {
            padded: false
            Button {
                id: readBtn
                variant: Button.Ghost
                size: Button.IconXs
                iconName: "check"
                Tooltip {
                    text: qsTr("Read on Jan 5, 2026 at 4:32 PM")
                    visible: readBtn.hovered
                }
            }
        }
    }
}
