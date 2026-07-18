import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import Shadcn

// Shadcn/QML 组件库 Gallery。用 QtQuick.Window 的 Window(不引 Controls),
// 避免与 Shadcn 的 Button 撞名。
Window {
    id: win
    width: 720
    height: 800
    visible: true
    color: Theme.background
    title: qsTr("Shadcn — QML Gallery")

    Component.onCompleted: {
        Theme.dark = appStartDark
        searchInput.forceActiveFocus() // 展示 Input 焦点环
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: "shadcn / QML"
                color: Theme.foreground
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Button {
                text: Theme.dark ? "Light" : "Dark"
                variant: Button.Outline
                onClicked: Theme.dark = !Theme.dark
            }
        }

        Separator { Layout.fillWidth: true }

        Text { text: "Buttons — variants"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 8
            Button { text: "Default" }
            Button { text: "Secondary"; variant: Button.Secondary }
            Button { text: "Outline"; variant: Button.Outline }
            Button { text: "Ghost"; variant: Button.Ghost }
            Button { text: "Destructive"; variant: Button.Destructive }
        }

        Text { text: "Buttons — sizes"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 8
            Button { text: "Small"; size: Button.Small }
            Button { text: "Default" }
            Button { text: "Large"; size: Button.Large }
        }

        Text { text: "Badges"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 8
            Badge { text: "Default" }
            Badge { text: "Secondary"; variant: Badge.Secondary }
            Badge { text: "Outline"; variant: Badge.Outline }
            Badge { text: "Destructive"; variant: Badge.Destructive }
        }

        Text { text: "Icon buttons"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 8
            IconButton { iconName: "undo-2" }
            IconButton { iconName: "redo-2" }
            IconButton { iconName: "zoom-in" }
            IconButton { iconName: "download"; variant: IconButton.Outline }
            IconButton { iconName: "trash-2"; variant: IconButton.Destructive }
        }

        Text { text: "Input & Card"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 12
            Input {
                id: searchInput
                Layout.preferredWidth: 240
                placeholderText: qsTr("Search shapes…")
            }
            Card {
                RowLayout {
                    spacing: 8
                    Badge { text: "Container" }
                    Text { text: "API Application"; color: Theme.foreground; font.pixelSize: 13 }
                }
            }
        }

        Text { text: "Form controls"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 12
            Label { text: "Notation" }
            Select {
                Layout.preferredWidth: 160
                model: ["Architecture", "Flowchart"]
            }
            Checkbox { text: "Snap to grid"; checked: true }
            Checkbox { text: "Show ports" }
        }
        Textarea {
            Layout.preferredWidth: 360
            Layout.preferredHeight: 56
            placeholderText: qsTr("Describe this element…")
        }

        Text { text: "Tabs"; color: Theme.mutedForeground; font.pixelSize: 12 }
        Tabs {
            TabButton { text: "Library" }
            TabButton { text: "Outline" }
        }

        Text { text: "Overlays"; color: Theme.mutedForeground; font.pixelSize: 12 }
        RowLayout {
            spacing: 8
            Button {
                text: "Open menu"
                variant: Button.Outline
                onClicked: demoMenu.popup()
            }
            Button {
                text: "Open dialog"
                onClicked: demoDialog.open()
            }
        }

        Item { Layout.fillHeight: true }
    }

    // 构造以验证加载(弹层在 offscreen 抓图里不显示,但能验证无 QML 错误)。
    Menu {
        id: demoMenu
        MenuItem { text: "New Project"; shortcut: "⌘N"; iconName: "file-plus" }
        MenuItem { text: "Open…"; shortcut: "⌘O" }
        MenuSeparator {}
        MenuItem { text: "Export…"; shortcut: "⇧⌘E"; iconName: "download" }
    }

    Dialog {
        id: demoDialog
        title: qsTr("New Project")
        description: qsTr("Create a project — one file, many linked pages.")
        ColumnLayout {
            spacing: 12
            Label { text: "Project name" }
            Input { Layout.preferredWidth: 300; text: "Untitled Project" }
        }
    }

    Tooltip { id: demoTooltip; text: qsTr("A tooltip") }
}
