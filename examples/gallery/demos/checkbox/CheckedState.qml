import QtQuick
import QtQuick.Layouts
import Shadcn

// Checked / unchecked states —— checked 属性控制勾选,默认关闭。
ColumnLayout {
    spacing: 12
    Checkbox { text: qsTr("Unchecked") }
    Checkbox { text: qsTr("Checked"); checked: true }
}
