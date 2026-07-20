import QtQuick
import QtQuick.Layouts
import Shadcn

// Align Item With Trigger:开关切换 alignItemWithTrigger。
// true → 弹层上移使当前项(Banana)覆盖触发器;false → 贴触发器下沿弹出。
// 注:简化实现,不含滚动/视口夹取,适用于条目较少可完整显示的场景。
ColumnLayout {
    width: 260
    spacing: 12

    RowLayout {
        Layout.fillWidth: true
        spacing: 12
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Label { text: "Align Item" }
            Text {
                text: "Toggle to align the item with the trigger."
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
        Switch {
            id: alignSwitch
            checked: true
        }
    }

    Select {
        Layout.fillWidth: true
        alignItemWithTrigger: alignSwitch.checked
        currentIndex: 1     // Banana
        model: ["Apple", "Banana", "Blueberry", "Grapes", "Pineapple"]
    }
}
