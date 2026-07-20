import QtQuick
import QtQuick.Layouts

// shadcn FieldError —— 校验错误容器(role="alert",text-destructive text-xs)。
// 用法一:text 直接给单条错误。
// 用法二:errors 给字符串数组(自动去重);>1 条渲染为项目符号列表。
// 无内容时自动隐藏(visible=false)。
ColumnLayout {
    id: err

    property string text: ""
    property var errors: []

    // 归一化 + 去重后的错误列表。
    readonly property var _list: {
        if (text !== "")
            return [text]
        if (!errors || errors.length === 0)
            return []
        var seen = ({})
        var out = []
        for (var i = 0; i < errors.length; i++) {
            var m = errors[i]
            if (m && !seen[m]) {
                seen[m] = true
                out.push(m)
            }
        }
        return out
    }

    Layout.fillWidth: true
    spacing: Theme.space1
    visible: _list.length > 0

    Repeater {
        model: err._list
        delegate: Text {
            required property string modelData
            Layout.fillWidth: true
            // 多条时前置项目符号(对标 list-disc)。
            text: err._list.length > 1 ? ("•  " + modelData) : modelData
            color: Theme.destructive
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
        }
    }
}
