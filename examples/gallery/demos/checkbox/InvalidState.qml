import QtQuick
import QtQuick.Layouts
import Shadcn

// aria-invalid —— destructive-color border + ring. When checked the border still returns to primary (mira-style).
ColumnLayout {
    width: 240
    spacing: 12
    Checkbox { text: qsTr("Accept terms and conditions"); invalid: true }
    Checkbox { text: qsTr("Accept terms and conditions"); invalid: true; checked: true }
}
