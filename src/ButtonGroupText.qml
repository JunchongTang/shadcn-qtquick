import QtQuick

// shadcn ButtonGroupText —— 组内文本(cn-button-group-text:bg-muted、rounded-md、border、
// px-2.5、text-xs/relaxed、font-medium)。含 groupPosition,由 ButtonGroup 自动拉直相邻内侧角。
Rectangle {
    id: control

    property alias text: label.text
    // 在 ButtonGroup 中的相邻位置(由 ButtonGroup 自动设置)。
    property int groupPosition: Button.GroupNone
    property bool groupVertical: false

    implicitHeight: 28
    implicitWidth: label.implicitWidth + Theme.space2_5 * 2   // px-2.5
    color: Theme.muted
    radius: Theme.radiusMd
    border.width: 1
    border.color: Theme.border

    // 分组时拉直相邻内侧角(逐角推导,机制同 Button)。
    readonly property bool _n: groupPosition === Button.GroupNone
    readonly property bool _f: groupPosition === Button.GroupFirst
    readonly property bool _l: groupPosition === Button.GroupLast
    readonly property bool _v: groupVertical
    topLeftRadius:     (_n || _f) ? radius : 0
    bottomRightRadius: (_n || _l) ? radius : 0
    topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? radius : 0
    bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? radius : 0

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.foreground
        font.pixelSize: Theme.textXs      // text-xs
        font.weight: Font.Medium
    }
}
