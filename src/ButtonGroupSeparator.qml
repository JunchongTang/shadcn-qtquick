import QtQuick

// shadcn ButtonGroupSeparator —— 组内分隔线(cn-button-group-separator: bg-input)。
// 用于 secondary 等无边框按钮之间的视觉分隔。默认竖向(组内横向排列时)。
// 因分隔线会被 ButtonGroup 的 spacing:-1 吞掉,请放进 spacing:0 的手工组合,
// 相邻 Button 手动设 groupPosition;见 demos/button-group/Separator.qml、Split.qml。
Rectangle {
    enum Orientation { Horizontal, Vertical }
    property int orientation: ButtonGroupSeparator.Vertical
    property real length: 24   // 与相邻按钮同高(竖向)/同宽(横向),按钮尺寸不同请覆盖

    color: Theme.input
    implicitWidth: orientation === ButtonGroupSeparator.Vertical ? 1 : length
    implicitHeight: orientation === ButtonGroupSeparator.Vertical ? length : 1
}
