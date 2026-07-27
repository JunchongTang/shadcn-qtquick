import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Official collapsible-file-tree —— a file tree built from nested Collapsibles.
// Folders are collapsible trigger rows (chevron rotates 90° + folder icon), files are
// static rows, child levels indent 20px.
Card {
    id: root
    width: 256
    size: Card.Small

    // Generic row: folder (with rotating chevron) or file.
    component TreeRow: Rectangle {
        id: rowRoot
        property string label: ""
        property string leadingIcon: "file"
        property bool isFolder: false
        property bool open: false
        signal activated()

        Layout.fillWidth: true
        implicitHeight: 24
        radius: Theme.radiusSm
        color: hover.hovered ? Theme.accent : "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            spacing: 6
            LucideIcon {
                visible: rowRoot.isFolder
                name: "chevron-right"
                size: 14
                color: Theme.mutedForeground
                rotation: rowRoot.open ? 90 : 0
                Behavior on rotation { NumberAnimation { duration: Theme.durFast } }
            }
            Item {
                visible: !rowRoot.isFolder
                implicitWidth: 14
                implicitHeight: 14
            }
            LucideIcon {
                name: rowRoot.leadingIcon
                size: 14
                color: rowRoot.isFolder ? Theme.foreground : Theme.mutedForeground
            }
            Text {
                Layout.fillWidth: true
                text: rowRoot.label
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        HoverHandler { id: hover }
        TapHandler { onTapped: rowRoot.activated() }
    }

    // Folder: collapsible, trigger row uses TreeRow (folder styling).
    component Folder: Collapsible {
        id: f
        property string label: ""
        Layout.fillWidth: true
        gap: 4
        trigger: TreeRow {
            width: parent.width
            label: f.label
            leadingIcon: "folder"
            isFolder: true
            open: f.expanded
            onActivated: f.toggle()
        }
    }

    CardHeader {
        Tabs {
            Layout.fillWidth: true
            TabButton { text: qsTr("Explorer") }
            TabButton { text: qsTr("Outline") }
        }
    }

    CardContent {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Folder {
                label: qsTr("components")
                Folder {
                    Layout.leftMargin: 20
                    label: qsTr("ui")
                    TreeRow { Layout.leftMargin: 20; label: qsTr("button.tsx") }
                    TreeRow { Layout.leftMargin: 20; label: qsTr("card.tsx") }
                    TreeRow { Layout.leftMargin: 20; label: qsTr("dialog.tsx") }
                    TreeRow { Layout.leftMargin: 20; label: qsTr("input.tsx") }
                }
                TreeRow { Layout.leftMargin: 20; label: qsTr("login-form.tsx") }
                TreeRow { Layout.leftMargin: 20; label: qsTr("register-form.tsx") }
            }
            Folder {
                label: qsTr("lib")
                TreeRow { Layout.leftMargin: 20; label: qsTr("utils.ts") }
                TreeRow { Layout.leftMargin: 20; label: qsTr("cn.ts") }
                TreeRow { Layout.leftMargin: 20; label: qsTr("api.ts") }
            }
            Folder {
                label: qsTr("hooks")
                TreeRow { Layout.leftMargin: 20; label: qsTr("use-media-query.ts") }
                TreeRow { Layout.leftMargin: 20; label: qsTr("use-debounce.ts") }
            }
            TreeRow { label: qsTr("app.tsx") }
            TreeRow { label: qsTr("package.json") }
            TreeRow { label: qsTr("README.md") }
        }
    }
}
