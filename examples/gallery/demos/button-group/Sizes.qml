import QtQuick
import Shadcn

// 官方 button-group-size:用各按钮的 size 控制整组尺寸(sm / default / lg)。
Column {
    spacing: Theme.space8   // items gap-8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Sm; text: "Small" }
        Button { variant: Button.Outline; size: Button.Sm; text: "Button" }
        Button { variant: Button.Outline; size: Button.Sm; text: "Group" }
        Button { variant: Button.Outline; size: Button.IconSm; iconName: "plus" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: "Default" }
        Button { variant: Button.Outline; text: "Button" }
        Button { variant: Button.Outline; text: "Group" }
        Button { variant: Button.Outline; size: Button.Icon; iconName: "plus" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Lg; text: "Large" }
        Button { variant: Button.Outline; size: Button.Lg; text: "Button" }
        Button { variant: Button.Outline; size: Button.Lg; text: "Group" }
        Button { variant: Button.Outline; size: Button.IconLg; iconName: "plus" }
    }
}
