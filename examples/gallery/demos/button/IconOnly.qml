import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { iconName: "chevron-right"; size: Button.Icon }
    Button { iconName: "plus"; size: Button.IconSm; variant: Button.Secondary }
    Button { iconName: "settings"; size: Button.IconLg; variant: Button.Outline }
    IconButton { iconName: "star" }
    IconButton { iconName: "trash-2"; variant: IconButton.Destructive }
}
