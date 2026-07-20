import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    spacing: 10
    Checkbox { text: "Accept terms and conditions"; checked: true }
    Checkbox { text: "Enable notifications" }
    Checkbox { text: "Disabled"; enabled: false }
    Checkbox { text: "Disabled checked"; checked: true; enabled: false }
}
