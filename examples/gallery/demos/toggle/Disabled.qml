import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Toggle { enabled: false; text: "Disabled" }
    Toggle { enabled: false; variant: Toggle.Outline; text: "Disabled" }
}
