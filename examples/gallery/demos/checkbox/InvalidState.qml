import QtQuick
import QtQuick.Layouts
import Shadcn

// aria-invalid —— 破坏色描边 + 环。选中时描边仍回到 primary(仿 mira)。
ColumnLayout {
    width: 240
    spacing: 12
    Checkbox { text: "Accept terms and conditions"; invalid: true }
    Checkbox { text: "Accept terms and conditions"; invalid: true; checked: true }
}
