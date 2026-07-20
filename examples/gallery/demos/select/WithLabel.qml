import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 220
    spacing: 6
    Label { text: "Fruit" }
    Select {
        Layout.fillWidth: true
        model: ["Apple", "Banana", "Blueberry"]
    }
}
