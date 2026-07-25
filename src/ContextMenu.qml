import QtQuick

/*!
    \qmltype ContextMenu
    \inqmlmodule Shadcn
    \inherits Menu
    \brief A right-click context menu, styled to match shadcn/ui (base-mira).
    \image context-menu.png


    ContextMenu is a thin wrapper over \l Menu. It reuses the Menu popover
    container, item delegates and enter/exit transitions (so its visuals are
    identical to DropdownMenu), and adds a single behavior: right-clicking (or
    trackpad secondary-click) anywhere on a \l target item pops the menu open at
    the cursor position.

    Declare menu items as children, exactly as for \l Menu, and point \l target
    at the item whose right-clicks should open the menu:

    \qml
    Item {
        id: area
        width: 320; height: 180

        ContextMenu {
            target: area
            MenuItem { text: "Back" }
            MenuItem { text: "Forward"; enabled: false }
            MenuItem { text: "Reload" }
        }
    }
    \endqml

    \note Because ContextMenu derives from Menu (which inherits Popup), the
    per-item width sizing from Menu (content width tracks the widest item) is
    inherited unchanged.
*/
Menu {
    id: control

    /*!
        \qmlproperty Item ContextMenu::target

        The item whose right-click (or trackpad secondary-click) opens this
        menu. A \l TapHandler accepting \c Qt.RightButton is installed on the
        target; the menu pops up at the click position.

        When changed, the previous handler is destroyed and a new one is
        created on the new target. Setting it to \c null removes the handler.
        The default value is \c null.
    */
    property Item target: null

    // Rebuild the right-click TapHandler whenever the target changes.
    onTargetChanged: {
        if (control._handler) {
            control._handler.destroy()
            control._handler = null
        }
        if (control.target)
            control._handler = control._handlerComp.createObject(control.target)
    }

    // The live TapHandler, parented to target (null when no target is set).
    // Kept in an explicit property so it is not treated as a menu item.
    property QtObject _handler: null

    // Destroy the handler when the menu itself is torn down, so it does not
    // outlive the menu with a dangling reference when the target survives.
    Component.onDestruction: {
        if (control._handler) {
            control._handler.destroy()
            control._handler = null
        }
    }

    // Assigned to an explicit property (not the default contentData list) so
    // the Component is not mistaken for a menu item.
    property Component _handlerComp: Component {
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: function(eventPoint) {
                // Map the click point from the target's coordinate system into
                // the menu's parent coordinate system, which is what popup(x, y)
                // expects. When target === menu parent this is an identity map.
                const p = control.target.mapToItem(control.parent,
                                                    eventPoint.position.x,
                                                    eventPoint.position.y)
                control.popup(p.x, p.y)
            }
        }
    }
}
