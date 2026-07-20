import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 spinner-color:通过 color 覆盖旋转图标颜色。
// 这些是演示用的自定义颜色(Tailwind 500 色阶字面量),非设计令牌,故直接给 hex。
RowLayout {
    spacing: Theme.space6                 // gap-6

    Spinner { size: 24; color: "#ef4444" }   // red-500
    Spinner { size: 24; color: "#22c55e" }   // green-500
    Spinner { size: 24; color: "#3b82f6" }   // blue-500
    Spinner { size: 24; color: "#eab308" }   // yellow-500
    Spinner { size: 24; color: "#a855f7" }   // purple-500
}
