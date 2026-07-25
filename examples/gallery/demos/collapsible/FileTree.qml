import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 官方 collapsible-file-tree —— 用嵌套 Collapsible 搭出文件树。
// 文件夹为可折叠触发行(chevron 旋转 90° + 文件夹图标),文件为静态行,子层缩进 20px。
Card {
    id: root
    width: 256
    size: Card.Small

    // 通用行:文件夹(带旋转 chevron)或文件。
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

    // 文件夹:可折叠,触发行用 TreeRow(folder 样式)。
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
