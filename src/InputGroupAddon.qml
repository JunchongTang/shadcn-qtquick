import QtQuick
import QtQuick.Layouts

// shadcn InputGroupAddon —— 组内插槽:图标 / 文本(InputGroupText)/ 小按钮(InputGroupButton)/ Kbd / Spinner。
// 不重复边框:仅提供内边距与横向排布,视觉边框由 InputGroup 统一给出。
// align 决定定位与内边距:inline-start/inline-end(横向两端)、block-start/block-end(纵向上下)。
// 点击空白处聚焦组内控件(cursor-text 语义);点在按钮上时按钮优先。
Item {
    id: addon

    enum Align { InlineStart, InlineEnd, BlockStart, BlockEnd }

    property int align: InputGroupAddon.InlineStart
    // border:block addon 画一条分隔线(block-start→下边框,block-end→上边框),对标 .border-b / .border-t。
    property bool border: false

    // 供 InputGroup 分拣的对齐字符串
    readonly property string igAlign: {
        switch (align) {
        case InputGroupAddon.InlineEnd:  return "inline-end"
        case InputGroupAddon.BlockStart: return "block-start"
        case InputGroupAddon.BlockEnd:   return "block-end"
        default:                         return "inline-start"
        }
    }
    readonly property bool _block: align === InputGroupAddon.BlockStart
                                || align === InputGroupAddon.BlockEnd

    property var _group: null   // 由 InputGroup 在重排时注入,用于点击聚焦

    default property alias content: row.data

    // 含按钮时把该侧内边距收紧(对标 has-[>button]:ml/mr-[-0.275rem])
    readonly property bool _edgePull: {
        for (var i = 0; i < row.children.length; i++) {
            var c = row.children[i]
            if (c && c.hasOwnProperty && c.hasOwnProperty("_igButton"))
                return true
        }
        return false
    }

    // 内边距(px-2 / py-2;inline 侧含按钮收紧 8→4)
    readonly property real _padL: {
        if (_block) return Theme.space2
        if (align === InputGroupAddon.InlineStart) return _edgePull ? Theme.space1 : Theme.space2
        return 0
    }
    readonly property real _padR: {
        if (_block) return Theme.space2
        if (align === InputGroupAddon.InlineEnd) return _edgePull ? Theme.space1 : Theme.space2
        return 0
    }
    readonly property real _padT: {
        if (align === InputGroupAddon.BlockStart) return Theme.space2
        if (align === InputGroupAddon.BlockEnd)   return addon.border ? Theme.space2 : 0
        return 0
    }
    readonly property real _padB: {
        if (align === InputGroupAddon.BlockEnd)   return Theme.space2
        if (align === InputGroupAddon.BlockStart) return addon.border ? Theme.space2 : 0
        return 0
    }

    implicitWidth: row.implicitWidth + _padL + _padR
    implicitHeight: row.implicitHeight + _padT + _padB + (_block ? 0 : Theme.space1 * 2)

    // 分隔线(仅 block 且 border 时)
    Rectangle {
        visible: addon.border && addon._block
        width: parent.width
        height: 1
        color: Theme.border
        anchors.top: addon.align === InputGroupAddon.BlockEnd ? parent.top : undefined
        anchors.bottom: addon.align === InputGroupAddon.BlockStart ? parent.bottom : undefined
    }

    RowLayout {
        id: row
        spacing: Theme.space1                       // gap-1
        anchors.leftMargin: addon._padL
        anchors.rightMargin: addon._padR
        anchors.topMargin: addon._padT
        anchors.bottomMargin: addon._padB
        // inline:垂直居中并贴对应边;block:横向铺满(便于 InputGroupText 用 Layout.fillWidth 把按钮推到右侧)
        anchors.left: (addon._block || addon.align === InputGroupAddon.InlineStart) ? parent.left : undefined
        anchors.right: (addon._block || addon.align === InputGroupAddon.InlineEnd) ? parent.right : undefined
        anchors.verticalCenter: addon._block ? undefined : parent.verticalCenter
        anchors.top: addon._block ? parent.top : undefined
    }

    // 点击空白聚焦控件(按钮子项会优先抢占)
    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: if (addon._group) addon._group.focusControl()
    }
}
