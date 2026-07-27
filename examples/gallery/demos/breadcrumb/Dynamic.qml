import QtQuick
import QtQuick.Layouts
import Shadcn

// model-driven dynamic breadcrumb: the breadcrumb is pure presentation; state lives in the external path array.
// Reassigning path → Repeater rebuilds automatically. Demonstrates three dynamic transitions:
//   · Click a level's link → truncate to that level (the common "click breadcrumb to go up")
//   · Navigate deeper → append a new level to path
//   · Reset → restore the initial path
Column {
    id: root
    spacing: Theme.space4

    // Current path: one item per level, last item = current page (no link).
    property var path: [
        { label: qsTr("Home") },
        { label: qsTr("Components") },
        { label: qsTr("Breadcrumb") }
    ]
    // Next-level names cycled through when appending.
    readonly property var pool: ["Settings", "Profile", "Billing", "Team", "Details"]

    // ==== Breadcrumb: generated from path ====
    Breadcrumb {
        Repeater {
            id: rep
            model: root.path
            delegate: RowLayout {
                id: crumb
                required property int index
                required property var modelData
                readonly property bool isLast: index === rep.count - 1
                spacing: Theme.space1_5

                // No separator before the first item
                BreadcrumbSeparator { visible: crumb.index > 0 }

                BreadcrumbItem {
                    // Non-last item = clickable link; clicking truncates path to this level
                    BreadcrumbLink {
                        visible: !crumb.isLast
                        text: crumb.modelData.label
                        onClicked: root.path = root.path.slice(0, crumb.index + 1)
                    }
                    // Last item = current page
                    BreadcrumbPage {
                        visible: crumb.isLast
                        text: crumb.modelData.label
                    }
                }
            }
        }
    }

    // ==== Dynamic switching controls ====
    Row {
        spacing: Theme.space2

        Button {
            text: qsTr("Navigate deeper")
            variant: Button.Outline
            size: Button.Sm
            enabled: root.path.length < root.pool.length + 3
            // Take a name not yet in path and append it as the new current page
            onClicked: {
                var next = root.pool[(root.path.length - 3) % root.pool.length]
                root.path = root.path.concat([{ label: next }])
            }
        }
        Button {
            text: qsTr("Reset")
            variant: Button.Ghost
            size: Button.Sm
            onClicked: root.path = [
                { label: qsTr("Home") },
                { label: qsTr("Components") },
                { label: qsTr("Breadcrumb") }
            ]
        }
    }
}
