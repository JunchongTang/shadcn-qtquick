import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn NavigationMenuContent(base-mira)—— 导航项展开的下拉内容面板。
// 视觉对齐 .cn-navigation-menu-popup(rounded-xl + ring-1 ring-foreground/10 + shadow)
// 与 .cn-navigation-menu-content(p-1.5)。QtQuick.Controls 无 Popover 类型,基于 C.Popup 实现
//(与 Popover.qml 同源)。链接以 GridLayout 排布,columns=1 纵向堆叠、>1 为网格。
//
// 由 NavigationMenuItem 内部实例化;放入的 NavigationMenuLink 子项经默认属性进入内部网格。
C.Popup {
    id: content

    property int columns: 1
    property int sideOffset: 8   // side=bottom sideOffset 8

    // 默认内容槽:声明的 NavigationMenuLink 直接进入内部网格。
    default property alias links: grid.data
    // 供宿主 Item 感知面板是否被 hover(维持展开)。
    property alias hovered: panelHover.hovered

    width: 384                   // 默认 w-96;由 Item 覆盖
    padding: Theme.space1_5      // p-1.5
    font.pixelSize: Theme.textXs
    modal: false
    dim: false
    closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

    // 定位:触发头(parent)正下方,align=start。
    y: (parent ? parent.height : 0) + sideOffset
    x: 0

    background: Rectangle {
        color: Theme.popover
        radius: Theme.radiusXl   // rounded-xl
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }
    }

    contentItem: GridLayout {
        id: grid
        columns: content.columns
        rowSpacing: Theme.space2      // gap-2
        columnSpacing: Theme.space2

        // 覆盖整个面板的 hover 探测(不拦截链接点击)。
        HoverHandler { id: panelHover }
    }

    // 展开:fade + zoom(data-starting-style:scale-90 opacity-0)。收起对称。
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durBase }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: Theme.durBase }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.9; duration: Theme.durFast }
    }
}
