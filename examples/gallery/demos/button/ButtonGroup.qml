import QtQuick
import QtQuick.Layouts
import Shadcn

// Multiple ButtonGroups leave gap-2; adjacent Buttons within a group join edge-to-edge.
RowLayout {
    spacing: 8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-left" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Archive") }
        Button { variant: Button.Outline; text: qsTr("Report") }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Snooze") }
        Button { variant: Button.Outline; size: Button.Icon; iconName: "more-horizontal" }
    }
}
