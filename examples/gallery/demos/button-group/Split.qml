import QtQuick
import Shadcn

// Official button-group-split: one action button + separator + one icon button = split button.
// Same as Separator: manual spacing:0 composition + manual groupPosition.
Row {
    spacing: 0

    Button {
        variant: Button.Secondary
        text: qsTr("Button")
        groupPosition: Button.GroupFirst
    }
    ButtonGroupSeparator { length: 28 }   // default button height 28
    Button {
        variant: Button.Secondary
        size: Button.Icon
        iconName: "plus"
        groupPosition: Button.GroupLast
    }
}
