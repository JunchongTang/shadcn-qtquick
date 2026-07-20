import QtQuick
import QtQuick.Layouts

// shadcn MessageAvatar(base-mira)—— 消息行的头像槽:min-w-8、rounded-full、贴底。
// 空占位(无 source/fallback)时是 32px 宽的透明间隔件,用于 MessageGroup 中让
// 前序消息与末条消息的头像保持对齐(对应官方 `<MessageAvatar />` 空槽用法)。
// 注:官方 -translate-y-8(有 footer 时头像上移与气泡底对齐)未实现,基础版一律贴底。
Item {
    id: root

    property url source
    property string fallback: ""

    readonly property bool _empty: String(source) === "" && fallback === ""

    implicitWidth: Theme.space8      // min-w-8 = 32
    implicitHeight: Theme.space8
    Layout.alignment: Qt.AlignBottom // self-end

    Avatar {
        anchors.fill: parent
        visible: !root._empty
        source: root.source
        fallback: root.fallback
    }
}
