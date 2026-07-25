import QtQuick
import Shadcn

// 官方 button-group-size:用各按钮的 size 控制整组尺寸(sm / default / lg)。
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
