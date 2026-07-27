import QtQuick
import Shadcn

// Official kbd-tooltip: two buttons grouped together (ButtonGroup), tooltip text followed by a Kbd key hint.
// Note: Tooltip.kbd is a single string key; the combo (KbdGroup officially) is approximated here as the single key "Ctrl P".
ButtonGroup {
    Button {
        id: saveBtn
        text: qsTr("Save")
        variant: Button.Outline
        Tooltip { text: qsTr("Save Changes"); kbd: "S"; visible: saveBtn.hovered }
    }
    Button {
        id: printBtn
        text: qsTr("Print")
        variant: Button.Outline
        Tooltip { text: qsTr("Print Document"); kbd: "Ctrl P"; visible: printBtn.hovered }
    }
}
