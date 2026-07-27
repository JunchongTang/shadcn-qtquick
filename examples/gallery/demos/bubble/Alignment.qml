import QtQuick
import QtQuick.Layouts
import Shadcn

// Start/end alignment: start (default, recipient) / end (sender). Mirrors official bubble-alignment.
ColumnLayout {
    width: 360
    spacing: 32

    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: qsTr("This bubble is aligned to the start. This is the default alignment.")
        }
    }
    Bubble {
        align: Bubble.End
        BubbleContent {
            text: qsTr("This bubble is aligned to the end. Use this for user messages.")
        }
    }
}
