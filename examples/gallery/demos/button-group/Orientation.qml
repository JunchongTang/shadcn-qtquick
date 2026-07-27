import QtQuick
import Shadcn

// Official button-group-orientation: orientation=vertical lays out the whole group vertically (media controls).
// When vertical, ButtonGroup automatically flattens the top/bottom inner corners of adjacent buttons.
ButtonGroup {
    orientation: ButtonGroup.Vertical

    Button { variant: Button.Outline; size: Button.Icon; iconName: "plus" }
    Button { variant: Button.Outline; size: Button.Icon; iconName: "minus" }
}
