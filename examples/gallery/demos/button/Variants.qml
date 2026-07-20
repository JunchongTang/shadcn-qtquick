import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { text: "Default" }
    Button { text: "Secondary"; variant: Button.Secondary }
    Button { text: "Outline"; variant: Button.Outline }
    Button { text: "Ghost"; variant: Button.Ghost }
    Button { text: "Destructive"; variant: Button.Destructive }
    Button { text: "Link"; variant: Button.Link }
}
