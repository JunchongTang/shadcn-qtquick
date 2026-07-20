import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Toggle { variant: Toggle.Outline; iconName: "italic"; text: "Italic" }
    Toggle { variant: Toggle.Outline; iconName: "bold"; text: "Bold" }
}
