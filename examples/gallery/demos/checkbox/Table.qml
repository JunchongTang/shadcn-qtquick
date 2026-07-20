import QtQuick
import QtQuick.Layouts
import Shadcn

// 表格中的 Checkbox —— 表头「全选」+ 行选择。用 ColumnLayout/RowLayout + Separator 模拟表格行。
ColumnLayout {
    id: root
    width: 460
    spacing: 0

    property int selCount: 1
    readonly property bool allSelected: selCount === tableModel.count

    function recount() {
        var c = 0
        for (var i = 0; i < tableModel.count; i++)
            if (tableModel.get(i).sel) c++
        selCount = c
    }

    ListModel {
        id: tableModel
        ListElement { name: "Sarah Chen"; email: "sarah.chen@example.com"; role: "Admin"; sel: true }
        ListElement { name: "Marcus Rodriguez"; email: "marcus.rodriguez@example.com"; role: "User"; sel: false }
        ListElement { name: "Priya Patel"; email: "priya.patel@example.com"; role: "User"; sel: false }
        ListElement { name: "David Kim"; email: "david.kim@example.com"; role: "Editor"; sel: false }
    }

    // ---- 表头 ----
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 8
        Layout.rightMargin: 8
        Layout.preferredHeight: 40
        spacing: 12

        Checkbox {
            id: selectAll
            Layout.preferredWidth: 20
            Binding {
                target: selectAll; property: "checked"
                value: root.allSelected; restoreMode: Binding.RestoreBinding
            }
            onToggled: {
                for (var i = 0; i < tableModel.count; i++)
                    tableModel.setProperty(i, "sel", checked)
                root.recount()
            }
        }
        Text {
            Layout.fillWidth: true
            Layout.preferredWidth: 130
            text: "Name"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
        }
        Text {
            Layout.preferredWidth: 200
            text: "Email"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
        }
        Text {
            Layout.preferredWidth: 70
            text: "Role"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
        }
    }

    Separator { Layout.fillWidth: true }

    // ---- 数据行 ----
    Repeater {
        model: tableModel
        delegate: ColumnLayout {
            required property int index
            required property var model
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                spacing: 0

                // data-state=selected → bg-muted 行高亮
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: model.sel ? Theme.muted : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 12

                        Checkbox {
                            id: rowCb
                            Layout.preferredWidth: 20
                            Binding {
                                target: rowCb; property: "checked"
                                value: model.sel; restoreMode: Binding.RestoreBinding
                            }
                            onToggled: {
                                tableModel.setProperty(index, "sel", checked)
                                root.recount()
                            }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 130
                            text: model.name
                            color: Theme.foreground
                            font.pixelSize: Theme.textXs
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.preferredWidth: 200
                            text: model.email
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textXs
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.preferredWidth: 70
                            text: model.role
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textXs
                        }
                    }
                }
            }

            Separator {
                Layout.fillWidth: true
                visible: index < tableModel.count - 1
            }
        }
    }
}
