import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Badge { iconName: "badge-check"; text: qsTr("Verified") }
    Badge { iconName: "circle-alert"; text: qsTr("Alert"); variant: Badge.Destructive }
    Badge { text: "99+"; variant: Badge.Secondary }
}
