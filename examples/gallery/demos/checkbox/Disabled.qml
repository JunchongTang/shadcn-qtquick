import QtQuick
import QtQuick.Layouts
import Shadcn

// disabled —— 阻止交互并整体降透明度。
ColumnLayout {
    spacing: 12
    Checkbox { text: qsTr("Enable notifications"); enabled: false }
    Checkbox { text: qsTr("Enable notifications"); enabled: false; checked: true }
}
