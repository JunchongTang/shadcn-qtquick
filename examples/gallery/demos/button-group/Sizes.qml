import QtQuick
import Shadcn

// Official button-group-size: use each button's size to control the whole group's size (sm / default / lg).
Column {
    spacing: Theme.space8   // items gap-8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Sm; text: qsTr("Small") }
        Button { variant: Button.Outline; size: Button.Sm; text: qsTr("Button") }
        Button { variant: Button.Outline; size: Button.Sm; text: qsTr("Group") }
        Button { variant: Button.Outline; size: Button.IconSm; iconName: "plus" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Default") }
        Button { variant: Button.Outline; text: qsTr("Button") }
        Button { variant: Button.Outline; text: qsTr("Group") }
        Button { variant: Button.Outline; size: Button.Icon; iconName: "plus" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Lg; text: qsTr("Large") }
        Button { variant: Button.Outline; size: Button.Lg; text: qsTr("Button") }
        Button { variant: Button.Outline; size: Button.Lg; text: qsTr("Group") }
        Button { variant: Button.Outline; size: Button.IconLg; iconName: "plus" }
    }
}
