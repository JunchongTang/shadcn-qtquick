import QtQuick
import QtQuick.Layouts

// shadcn InputGroup(base-mira)—— 把输入与 addon/按钮/文本组合进「共享一个圆角边框 + 统一焦点环」的整体。
// 对标 .cn-input-group:border-input、bg-input/20(暗 /30)、h-7、rounded-md;控件聚焦 → border-ring + ring-2 ring/30。
//
// 组成:InputGroupInput 或 InputGroupTextarea + 若干 InputGroupAddon(内含 InputGroupText/InputGroupButton/图标/Kbd/Spinner)。
// 用法上按视觉顺序或任意顺序声明子项均可:本组件按各 addon 的 align 自动分拣定位。
//   inline-start / inline-end → 横向两端;block-start / block-end → 纵向上下(textarea 或块级 addon 时自动纵向)。
//
// 实现:FocusScope 使「组内任一控件聚焦」等价于 root.activeFocus,从而整组共享一个焦点环;
// 完成时把声明子项从暂存 Item 重排进横向中列(RowLayout)与纵向外列(ColumnLayout),并据 addon 存在情况覆写控件内边距。
FocusScope {
    id: root

    property bool invalid: false     // aria-invalid → 破坏色描边 + 环

    // 自动纵向:含 block addon 或 textarea 控件。可被外部显式赋值覆盖。
    property bool _hasBlock: false
    property bool _hasTextarea: false
    readonly property bool _autoVertical: _hasBlock || _hasTextarea
    property bool vertical: _autoVertical

    property var _firstControl: null

    default property alias _content: stash.data

    implicitWidth: 260
    implicitHeight: vertical ? colL.implicitHeight : 28

    // 暂存声明子项,Component.onCompleted 后分拣重排
    Item { id: stash }

    // ==== 共享边框 + 背景 + 焦点环 ====
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusMd
        color: Theme.alpha(Theme.input, 0.2)          // bg-input/20 微填充
        border.width: 1
        border.color: root.invalid ? Theme.destructive
                     : root.activeFocus ? Theme.ring : Theme.border
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: root.invalid
            z: -1
        }

        FocusRing { active: root.activeFocus; targetRadius: bg.radius }
    }

    // ==== 布局容器 ====
    // 横向中列:inline-start addon → 控件 → inline-end addon
    RowLayout { id: mid; spacing: 0 }
    // 纵向外列:block-start addon → 中列 → block-end addon
    ColumnLayout {
        id: colL
        spacing: 0
        visible: root.vertical
        anchors.fill: parent
    }

    Component.onCompleted: _rebuild()

    function focusControl() {
        if (_firstControl)
            _firstControl.forceActiveFocus()
    }

    function _rebuild() {
        var kids = []
        for (var i = 0; i < stash.children.length; i++)
            kids.push(stash.children[i])

        var starts = [], ends = [], ctrls = [], bStarts = [], bEnds = []
        var hasBlk = false, hasTa = false

        for (var k = 0; k < kids.length; k++) {
            var c = kids[k]
            if (c.hasOwnProperty && c.hasOwnProperty("_igControl")) {
                ctrls.push(c)
                if (c._igType === "textarea") hasTa = true
            } else if (c.hasOwnProperty && c.hasOwnProperty("igAlign")) {
                c._group = root
                switch (c.igAlign) {
                case "inline-end":  ends.push(c); break
                case "block-start": bStarts.push(c); hasBlk = true; break
                case "block-end":   bEnds.push(c); hasBlk = true; break
                default:            starts.push(c)
                }
            } else {
                starts.push(c)   // 未知内容按 inline-start 处理
            }
        }

        _hasBlock = hasBlk
        _hasTextarea = hasTa

        var hasStart = starts.length > 0
        var hasEnd   = ends.length > 0
        var hasBS    = bStarts.length > 0
        var hasBE    = bEnds.length > 0

        // 中列:starts → ctrls → ends
        var midItems = starts.concat(ctrls).concat(ends)
        for (var m = 0; m < midItems.length; m++)
            midItems[m].parent = mid

        // 控件内边距(按 addon 存在覆写)+ 充满宽度
        _firstControl = ctrls.length > 0 ? ctrls[0] : null
        for (var t = 0; t < ctrls.length; t++) {
            var ct = ctrls[t]
            ct.Layout.fillWidth = true
            var isTa = ct._igType === "textarea"
            ct.leftPadding  = hasStart ? Theme.space1_5 : Theme.space2   // pl-1.5 : px-2
            ct.rightPadding = hasEnd   ? Theme.space1_5 : Theme.space2   // pr-1.5 : px-2
            if (isTa) {
                ct.topPadding = Theme.space2
                ct.bottomPadding = Theme.space2
            } else {
                ct.topPadding    = hasBE ? Theme.space3 : 0   // block-end 存在 → pt-3
                ct.bottomPadding = hasBS ? Theme.space3 : 0   // block-start 存在 → pb-3
                ct.Layout.fillHeight = true
            }
        }
        for (var s = 0; s < starts.length; s++) starts[s].Layout.fillHeight = true
        for (var e = 0; e < ends.length; e++)   ends[e].Layout.fillHeight = true

        if (root.vertical) {
            for (var a = 0; a < bStarts.length; a++) { bStarts[a].parent = colL; bStarts[a].Layout.fillWidth = true }
            mid.parent = colL
            mid.Layout.fillWidth = true
            for (var b = 0; b < bEnds.length; b++) { bEnds[b].parent = colL; bEnds[b].Layout.fillWidth = true }
        } else {
            mid.parent = root
            mid.anchors.fill = root
        }
    }
}
