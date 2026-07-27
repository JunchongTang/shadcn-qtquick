import QtQuick
import Shadcn

// Official button-group-separator: borderless buttons like secondary are separated with ButtonGroupSeparator.
// The separator would be swallowed by ButtonGroup's spacing:-1, so use a manual spacing:0 composition + manual groupPosition.
Row {
    spacing: 0

    Button {
        variant: Button.Secondary
        size: Button.Sm
        text: qsTr("Copy")
        groupPosition: Button.GroupFirst
    }
    ButtonGroupSeparator { length: 24 }   // sm button height 24
    Button {
        variant: Button.Secondary
        size: Button.Sm
        text: qsTr("Paste")
        groupPosition: Button.GroupLast
    }
}
