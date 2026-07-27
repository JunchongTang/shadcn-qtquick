import QtQuick
import Shadcn

// Show a tooltip on a disabled button (matches tooltip-disabled: wrap in an outer span to receive hover).
// A disabled Button does not receive hover itself, so the outer Item's HoverHandler triggers it.
Item {
    id: wrapper
    implicitWidth: disabledBtn.implicitWidth
    implicitHeight: disabledBtn.implicitHeight

    HoverHandler { id: hh }

    Button {
        id: disabledBtn
        text: qsTr("Disabled")
        variant: Button.Outline
        enabled: false
    }

    Tooltip {
        text: qsTr("This feature is currently unavailable")
        visible: hh.hovered
    }
}
