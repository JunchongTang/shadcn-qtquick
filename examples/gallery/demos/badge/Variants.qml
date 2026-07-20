import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Badge { text: "Default" }
    Badge { text: "Secondary"; variant: Badge.Secondary }
    Badge { text: "Outline"; variant: Badge.Outline }
    Badge { text: "Destructive"; variant: Badge.Destructive }
}
