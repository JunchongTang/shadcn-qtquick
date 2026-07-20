import QtQuick
import QtQuick.Layouts

// shadcn BubbleReactions(base-mira)—— 叠在气泡边缘的表情/操作小胶囊。对标 .cn-bubble-reactions:
//   absolute z-10 · rounded-full · bg-muted · ring-2 ring-card(卡片色描边,与背后气泡分离)·
//   gap-1 px-1.5 py-0.5 text-xs · has-[button]:p-0(内含按钮时去内边距)。
// 定位(相对父 Bubble = 内容面外框):
//   side  top    → 顶边,向上偏移自身高 75%(top-0 -translate-y-3/4)
//   side  bottom → 底边,向下偏移自身高 75%(bottom-0 translate-y-3/4)
//   align start  → 距左 12px(left-3)   align end → 距右 12px(right-3)
//
// 内容:默认子项——放 Text{ text:"👍" } 表情或 Button/Tooltip/Popover 触发器。
//   内含交互控件时设 padded: false(对应 has-[button]:p-0)。
Item {
    id: reactions

    enum Side { Top, Bottom }

    property int side: BubbleReactions.Bottom
    property int align: Bubble.End          // 默认贴末端(对标 default align="end")
    property bool padded: true              // false ≈ has-[button]:p-0

    // 表情/控件默认槽。
    default property alias items: row.data

    readonly property real _padX: padded ? Theme.space1_5 : 0   // px-1.5
    readonly property real _padY: padded ? Theme.space0_5 : 0   // py-0.5
    readonly property real _ring: 2                              // ring-2

    z: 10
    implicitWidth: pill.width
    implicitHeight: pill.height

    // 相对父 Bubble 定位。
    x: align === Bubble.End ? (parent ? parent.width - width - Theme.space3 : 0) : Theme.space3
    y: side === BubbleReactions.Top ? -0.75 * height
                                    : (parent ? parent.height - 0.25 * height : 0)

    // 卡片色描边环(ring-2 ring-card):比胶囊四周各大 2px,营造与背后气泡的分离感。
    Rectangle {
        anchors.centerIn: pill
        width: pill.width + reactions._ring * 2
        height: pill.height + reactions._ring * 2
        radius: Theme.radiusFull
        color: Theme.card
    }

    Rectangle {
        id: pill
        width: row.implicitWidth + reactions._padX * 2
        height: row.implicitHeight + reactions._padY * 2
        radius: Theme.radiusFull
        color: Theme.muted

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: Theme.space1   // gap-1
        }
    }
}
