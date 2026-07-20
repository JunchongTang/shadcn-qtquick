import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-shimmer:MarkerContent 加 shimmer 微光(流式文本)。
// 近似说明:QML 无 background-clip:text 扫光,shimmer 以不透明度脉冲近似(见 Marker.qml)。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        shimmer: true
        text: "Thinking..."
    }
    Marker {
        variant: Marker.Separator
        shimmer: true
        text: "Reading 4 files"
    }
}
