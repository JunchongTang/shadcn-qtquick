import QtQuick
import QtQuick.Controls.Basic as C
import QtQml.Models
import LucideIcons

// shadcn Carousel(base-mira)—— 横向/纵向可滑动条目容器。
// 对标 embla:一个可拖拽/贴合的滚动区(基于 ListView),两侧(或上下)各一枚
// outline 圆形导航按钮(chevron)。条目由使用方以 CarouselItem 填入(default 内容槽)。
// align:start 语义 → 当前项贴合视口起点(StrictlyEnforceRange)。
// 简化:不实现 embla 的 loop/多插件;canScrollNext 以"是否到最后一项"近似。
Item {
    id: control

    enum Orientation { Horizontal, Vertical }
    property int orientation: Carousel.Horizontal

    // 条目间隔(对标 CarouselItem 的 pl-4 / pt-4 = 16;由条目内边距形成)。
    property real spacing: 16

    property alias currentIndex: view.currentIndex
    property alias count: view.count

    // 使用方填入的 CarouselItem 直接作为 ListView 的委托实例。
    default property alias content: itemsModel.children

    readonly property bool _horizontal: orientation === Carousel.Horizontal
    readonly property bool canScrollPrev: view.currentIndex > 0
    readonly property bool canScrollNext: view.currentIndex < view.count - 1

    implicitWidth: 320
    implicitHeight: _horizontal ? 200 : 320

    function scrollPrev() { if (canScrollPrev) view.currentIndex-- }
    function scrollNext() { if (canScrollNext) view.currentIndex++ }

    ObjectModel { id: itemsModel }

    ListView {
        id: view
        anchors.fill: parent
        clip: true
        model: itemsModel
        orientation: control._horizontal ? ListView.Horizontal : ListView.Vertical

        // align:start —— 当前项贴合起点并平滑滚动;拖拽后贴合到最近项。
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: 300
        highlight: null
        spacing: control.spacing        // 条目间隔:对称,不偏移内容
        boundsBehavior: Flickable.StopAtBounds

        // 供 CarouselItem 派生流向。
        property bool horizontalFlow: control._horizontal

        Keys.onLeftPressed: control.scrollPrev()
        Keys.onRightPressed: control.scrollNext()
    }

    // ==== 导航按钮:outline 圆形 + chevron(对标 .cn-carousel-previous/next → rounded-full)====
    component NavButton: C.Button {
        id: nav
        property string glyph
        implicitWidth: 28
        implicitHeight: 28
        padding: 0
        hoverEnabled: true
        opacity: enabled ? 1.0 : 0.5

        contentItem: Item {
            LucideIcon {
                anchors.centerIn: parent
                name: nav.glyph
                size: 14
                color: Theme.foreground
            }
        }
        background: Rectangle {
            radius: width / 2
            color: nav.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)
            border.width: 1
            border.color: Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durBase } }
            FocusRing { active: nav.visualFocus; targetRadius: nav.width / 2 }
        }
    }

    // 导航按钮与内容之间的间隙(对标官方 -left-12/-right-12:size-8 按钮外侧留约 16px)。
    readonly property real _navGap: Theme.space3   // 12

    NavButton {
        // 横向:内容左外侧居中;纵向:内容上外侧居中(chevron 朝上)。完全在内容外,不遮挡卡片。
        glyph: control._horizontal ? "chevron-left" : "chevron-up"
        enabled: control.canScrollPrev
        onClicked: control.scrollPrev()
        x: control._horizontal ? -(width + control._navGap) : (control.width - width) / 2
        y: control._horizontal ? (control.height - height) / 2 : -(height + control._navGap)
    }

    NavButton {
        // 横向:内容右外侧居中;纵向:内容下外侧居中(chevron 朝下)。完全在内容外,不遮挡卡片。
        glyph: control._horizontal ? "chevron-right" : "chevron-down"
        enabled: control.canScrollNext
        onClicked: control.scrollNext()
        x: control._horizontal ? control.width + control._navGap : (control.width - width) / 2
        y: control._horizontal ? (control.height - height) / 2 : control.height + control._navGap
    }
}
