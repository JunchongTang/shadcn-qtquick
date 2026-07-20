import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Badge { iconName: "badge-check"; text: "Verified" }
    Badge { iconName: "circle-alert"; text: "Alert"; variant: Badge.Destructive }
    Badge { text: "99+"; variant: Badge.Secondary }
}
