import QtQuick
// This file is named Avatar.qml, the same name as Shadcn's Avatar → import via namespace S. to avoid "same-directory self-reference" recursion.
import Shadcn as S

// Avatar-triggered account switcher menu (DropdownMenuTrigger render=ghost icon rounded-full + Avatar; align=end).
S.Avatar {
    id: trigger
    fallback: "LR"
    source: "https://github.com/shadcn.png"

    // align=end: menu right edge aligns to avatar right edge (uses a constant width to avoid width not yet being evaluated at popup time)
    TapHandler { onTapped: menu.popup(trigger.width - menu._w, trigger.height + 4) }

    S.Menu {
        id: menu
        readonly property int _w: 180
        implicitWidth: _w

        S.MenuItem { text: qsTr("Account"); iconName: "badge-check" }
        S.MenuItem { text: qsTr("Billing"); iconName: "credit-card" }
        S.MenuItem { text: qsTr("Notifications"); iconName: "bell" }
        S.MenuSeparator {}
        S.MenuItem { text: qsTr("Sign Out"); iconName: "log-out" }
    }
}
