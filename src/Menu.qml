import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype Menu
    \inqmlmodule Shadcn
    \inherits Menu
    \brief Popover container for the shadcn DropdownMenu family.

    Menu is the QML port of shadcn/ui's \c DropdownMenuContent (base-mira
    style, backed by base-ui's Menu). It is a \l[QtQuickControls]{Menu} (a
    Popup-derived container) drawn as a rounded popover with a subtle ring and
    drop shadow. Declare \l MenuItem, \l MenuCheckboxItem, \l MenuRadioItem,
    \l MenuLabel and \l MenuSeparator children to build the menu; nesting a
    \l Menu inside an item creates a submenu whose trigger renders a trailing
    chevron.

    The file name shadows the Controls base type, so the base is imported under
    the \c C alias and used as the root (\c C.Menu).

    \note Issue #021: the base Menu clamps its width to the background
    min-width, so \l contentWidth is bound to the widest item's implicitWidth
    to keep labels from being elided. Issue #002: the earlier hover drag-shadow
    Behavior has been removed and must not be reintroduced.
*/
C.Menu {
    id: control

    padding: Theme.space1            // p-1
    font.pixelSize: Theme.textXs
    overlap: 0
    modal: false

    // The base Menu does not grow to fit its widest item: its ListView
    // contentItem reports no content width, so the menu clamps to the
    // background min-width and elides long labels. Bind contentWidth to the
    // widest item's implicitWidth so every label is shown in full (#021).
    contentWidth: {
        var w = 0
        for (var i = 0; i < count; i++) {
            var it = itemAt(i)
            if (it && it.implicitWidth > w)
                w = it.implicitWidth
        }
        return w
    }

    // Submenu trigger items (a nested Menu) are instantiated by this delegate,
    // reusing the styled MenuItem, which draws the trailing chevron.
    delegate: MenuItem {}

    // Popover surface: rounded-lg + ring-1 ring-foreground/10 + shadow-md.
    background: Rectangle {
        implicitWidth: 128           // min-w-32 = 8rem
        color: Theme.popover
        radius: Theme.radiusLg
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

    // Open/close animation: fade + zoom-95 (data-open:fade-in / zoom-in-95).
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
    }
}
