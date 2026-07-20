import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Tabs(分段胶囊 · segmented pill)—— 无前缀,基类别名导入(as C)。
// 作为容器:muted 底、radiusLg、内边距 p-[3px],横向排布 TabButton。
// variant=Line:无 muted 底(bg-transparent)、rounded-none、trigger 间 gap-1,激活项改用底部下划线。
// vertical=true:TabButton 竖排(orientation vertical),下划线移至右侧。
// 内容切换交由使用方(StackLayout.currentIndex ↔ Tabs.currentIndex),此处不管理内容。
C.TabBar {
    id: control

    enum Variant { Default, Line }

    property int variant: Tabs.Default
    property bool vertical: false

    readonly property bool _line: variant === Tabs.Line

    // 竖排时逐项累加,横排时求各项之和(min h-8=32)。仅用于自适应尺寸,demo 也可显式覆盖。
    readonly property real _maxChildWidth: {
        let w = 0
        for (let i = 0; i < contentChildren.length; i++) {
            const it = contentChildren[i]
            if (it && it.implicitWidth > w) w = it.implicitWidth
        }
        return w
    }
    readonly property real _sumChildWidth: {
        let s = 0, n = 0
        for (let i = 0; i < contentChildren.length; i++) {
            const it = contentChildren[i]
            if (it) { s += it.implicitWidth; n++ }
        }
        return s + Math.max(0, n - 1) * spacing
    }

    padding: Theme.space1 - 1        // p-[3px]
    spacing: _line ? Theme.space1 : 0  // line: gap-1;default 紧贴无间隙,激活胶囊填满

    implicitWidth: (vertical ? _maxChildWidth : _sumChildWidth) + leftPadding + rightPadding
    implicitHeight: vertical ? list.contentHeight + topPadding + bottomPadding : 32  // h-8

    contentItem: ListView {
        id: list
        model: control.contentModel
        currentIndex: control.currentIndex
        spacing: control.spacing
        orientation: control.vertical ? ListView.Vertical : ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem
        highlightMoveDuration: 0
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: 40
        preferredHighlightEnd: (control.vertical ? height : width) - 40
    }

    background: Rectangle {
        radius: control._line ? 0 : Theme.radiusLg   // line: rounded-none
        color: control._line ? "transparent" : Theme.muted
    }
}
