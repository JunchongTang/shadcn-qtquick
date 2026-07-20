import QtQuick
import QtQuick.Layouts

// shadcn ItemContent —— 承载 ItemTitle / ItemDescription 的纵向内容列(flex-1 拉伸)。
// gap-1(xs → gap-0.5)。第二个及以后的 ItemContent 由父 Item 设为不拉伸(flex-none)。
ColumnLayout {
    id: content

    readonly property string itemSlot: "item-content"
    property int hostSize: 0           // 由父 Item 注入(0/1/2)
    property bool contentFill: true    // flex-1;第二个 content 会被置 false
    property bool hasDescription: false

    Layout.fillWidth: contentFill
    Layout.alignment: Qt.AlignVCenter
    spacing: hostSize === 2 ? 2 : 4     // gap-0.5 / gap-1

    Component.onCompleted: {
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c && c.itemSlot === "item-description") {
                hasDescription = true
                break
            }
        }
    }
}
