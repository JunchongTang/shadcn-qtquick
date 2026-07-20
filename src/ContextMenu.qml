import QtQuick

// shadcn ContextMenu(base-mira)—— 右键触发的菜单。
// 视觉与项类型完全复用 DropdownMenu:本类以 Menu 为根 → 继承其 popover 容器、
// 子菜单 delegate 与进出场动效(cn-context-menu-* 与 cn-dropdown-menu-* 视觉一致);
// 仅新增「目标区域右键 → 光标处弹出」的触发行为。
// 用法:声明于触发区域内(其 parent 即该区域),并令 target 指向该区域 Item。
Menu {
    id: control

    // 触发区域:在其上「鼠标右键 / 触摸板辅助点击」即在光标处弹出本菜单。
    property Item target: null

    // target 变更 → 在其上重建右键 TapHandler。
    onTargetChanged: {
        if (control._handler) {
            control._handler.destroy()
            control._handler = null
        }
        if (control.target)
            control._handler = control._handlerComp.createObject(control.target)
    }

    property QtObject _handler: null

    // 显式绑定到属性(而非默认属性 contentData),避免被当作菜单项。
    property Component _handlerComp: Component {
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: function(eventPoint) {
                // 光标点从 target 坐标系映射到菜单 parent 坐标系(通常二者相同 → 恒等)。
                const p = control.target.mapToItem(control.parent,
                                                    eventPoint.position.x,
                                                    eventPoint.position.y)
                control.popup(p.x, p.y)
            }
        }
    }
}
