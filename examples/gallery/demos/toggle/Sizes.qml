import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Toggle { variant: Toggle.Outline; size: Toggle.Sm; text: "Small" }
    Toggle { variant: Toggle.Outline; size: Toggle.Default; text: "Default" }
    Toggle { variant: Toggle.Outline; size: Toggle.Lg; text: "Large" }
}
