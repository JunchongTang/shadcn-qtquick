import QtQuick

// shadcn Button Group(base-mira)—— 让相邻控件(Button / Input / Select / ButtonGroupText)
// 首尾相接成一体。对齐 style-mira 的 .cn-button-group:相邻项拉直内侧圆角、共享一条边框。
//
// 实现:
//   · spacing -1 让相邻 1px 边框重合为一条(避免双线);
//   · 自动为每个含 groupPosition 的子项指派 First/Middle/Last(单项时 None),
//     子项据此拉直内侧角;含 groupVertical 的子项在纵向时改拉直上/下角。
//   · orientation 决定横向(单行)或纵向(单列)。用 Grid + 单行/单列约束实现,
//     以便同一组件同时支持两向(Row/Column 无法二合一)。
//
// 说明:
//   · 「组间留白(nested,gap-2)」请在外层用 Row/Column { spacing: 8 } 套多个 ButtonGroup,
//     见 demos/button-group/Nested.qml、Demo.qml。
//   · 带分隔线的分组(Separator / Split)因分隔线会被 spacing:-1 吞掉,改用
//     spacing:0 的手工组合 + ButtonGroupSeparator,见 demos/button-group/Separator.qml。
Grid {
    id: group

    enum Orientation { Horizontal, Vertical }
    property int orientation: ButtonGroup.Horizontal

    // 单行:rows=1、columns 自动(-1);单列:columns=1、rows 自动。
    // 注意:另一维必须留 -1(自动),不能填大数——Grid 会真的预留那么多行/列,
    // 叠加 spacing:-1 的负间距会把尺寸塌掉(竖向表现为整组不显示)。
    rows: orientation === ButtonGroup.Vertical ? -1 : 1
    columns: orientation === ButtonGroup.Vertical ? 1 : -1
    spacing: -1  // 相邻边框重合(避免双线)

    onChildrenChanged: Qt.callLater(_assignPositions)
    onOrientationChanged: _assignPositions()
    Component.onCompleted: _assignPositions()

    // 收集含 groupPosition 的子项(Button / Input / Select / ButtonGroupText),
    // 按首/中/尾指派拉角位置;含 groupVertical 者随组方向设置。
    function _assignPositions() {
        let items = []
        for (let i = 0; i < children.length; i++) {
            const c = children[i]
            if (c !== null && c.hasOwnProperty("groupPosition"))
                items.push(c)
        }
        const vertical = (orientation === ButtonGroup.Vertical)
        for (let j = 0; j < items.length; j++) {
            if (items[j].hasOwnProperty("groupVertical"))
                items[j].groupVertical = vertical
            if (items.length === 1)
                items[j].groupPosition = Button.GroupNone
            else if (j === 0)
                items[j].groupPosition = Button.GroupFirst
            else if (j === items.length - 1)
                items[j].groupPosition = Button.GroupLast
            else
                items[j].groupPosition = Button.GroupMiddle
        }
    }
}
