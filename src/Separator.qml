import QtQuick

// shadcn Separator —— 强类型枚举 orientation。
Rectangle {
    enum Orientation { Horizontal, Vertical }

    property int orientation: Separator.Horizontal

    color: Theme.border
    implicitWidth: orientation === Separator.Vertical ? 1 : 100
    implicitHeight: orientation === Separator.Vertical ? 100 : 1
}
