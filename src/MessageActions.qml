import QtQuick
import QtQuick.Layouts

// shadcn 消息 hover 操作组 —— 放在 MessageFooter 里的一组图标按钮(复制/点赞/重试…)。
// 默认子项即为按钮(通常 IconButton size=Small variant=Ghost)。
// `shown` 控制显隐:默认随消息 hover 淡入淡出;不可见时仍占位,避免布局跳动。
RowLayout {
    id: root

    property bool shown: true

    // 默认子项 → 操作按钮。
    default property alias actions: root.data

    spacing: 0
    opacity: shown ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
}
