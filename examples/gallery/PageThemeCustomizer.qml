import QtQuick
import QtQuick.Layouts
import Shadcn

// 主题定制器 —— 对标 ui.shadcn.com/create:调强调色/圆角/任意 token → 全库实时变样 → 导出 JSON。
// 依赖 Theme 的覆盖层(setToken/setRadius/resetTheme/exportJson/colorTokenNames/tokenColor)。
PageScaffold {
    id: page
    description: qsTr("Adjust brand color, radius and any design token — every component updates live. Export the config to rebrand the whole library.")

    // 强调色预设:设置 primary + primaryForeground(明暗两套)。
    readonly property var accents: [
        { name: "Amber",   lp: "#fdc700", lf: "#733e0a", dp: "#f0b100", df: "#733e0a" },
        { name: "Neutral", lp: "#171717", lf: "#fafafa", dp: "#fafafa", df: "#171717" },
        { name: "Blue",    lp: "#2563eb", lf: "#ffffff", dp: "#3b82f6", df: "#ffffff" },
        { name: "Green",   lp: "#059669", lf: "#ffffff", dp: "#10b981", df: "#052e16" },
        { name: "Rose",    lp: "#e11d48", lf: "#ffffff", dp: "#f43f5e", df: "#4c0519" },
        { name: "Violet",  lp: "#7c3aed", lf: "#ffffff", dp: "#8b5cf6", df: "#ffffff" },
        { name: "Orange",  lp: "#ea580c", lf: "#ffffff", dp: "#f97316", df: "#431407" }
    ]
    readonly property var radii: [0, 4, 8, 10, 14, 16]

    function applyAccent(a) {
        Theme.setToken("primary", a.lp, false); Theme.setToken("primaryForeground", a.lf, false)
        Theme.setToken("primary", a.dp, true);  Theme.setToken("primaryForeground", a.df, true)
    }
    function toHex(c) { return c.toString() }
    readonly property var _hexRe: /^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/

    // ---- 预设:强调色 + 圆角 ----
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: presetCol.implicitHeight + Theme.space4 * 2
        radius: Theme.radiusLg
        color: Theme.card
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing

        ColumnLayout {
            id: presetCol
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
            anchors.margins: Theme.space4
            spacing: Theme.space3

            Text { text: qsTr("Accent color"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
            Flow {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: page.accents
                    delegate: Button {
                        required property var modelData
                        text: modelData.name
                        variant: Button.Outline
                        onClicked: page.applyAccent(modelData)
                        // 左侧色点
                        iconName: ""
                        leftPadding: 26
                        Rectangle {
                            x: 8; anchors.verticalCenter: parent.verticalCenter
                            width: 12; height: 12; radius: 6
                            color: Theme.dark ? parent.modelData.dp : parent.modelData.lp
                            border.width: 1; border.color: Theme.alpha(Theme.foreground, 0.15)
                        }
                    }
                }
            }

            Text { text: qsTr("Radius"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium; Layout.topMargin: Theme.space2 }
            RowLayout {
                spacing: 8
                Repeater {
                    model: page.radii
                    delegate: Button {
                        required property var modelData
                        text: modelData + "px"
                        size: Button.Sm
                        variant: (Theme.radiusOverride < 0 ? 10 : Theme.radiusOverride) === modelData ? Button.Default : Button.Outline
                        onClicked: Theme.setRadius(modelData)
                    }
                }
            }
        }
    }

    // ---- 实时预览 ----
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: prevCol.implicitHeight + Theme.space4 * 2
        radius: Theme.radiusLg
        color: Theme.card
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing

        ColumnLayout {
            id: prevCol
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
            anchors.margins: Theme.space4
            spacing: Theme.space3

            Text { text: qsTr("Live preview"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
            Flow {
                Layout.fillWidth: true
                spacing: 8
                Button { text: qsTr("Primary") }
                Button { text: qsTr("Secondary"); variant: Button.Secondary }
                Button { text: qsTr("Outline"); variant: Button.Outline }
                Button { text: qsTr("Ghost"); variant: Button.Ghost }
                Button { text: qsTr("Destructive"); variant: Button.Destructive }
                Badge { text: qsTr("Badge") }
                Badge { text: qsTr("Secondary"); variant: Badge.Secondary }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                Input { Layout.preferredWidth: 200; placeholderText: qsTr("Email") }
                Switch { checked: true }
                Checkbox { text: qsTr("Accept"); checked: true }
                Progress { Layout.preferredWidth: 120; value: 60 }
            }
            Tabs {
                Layout.topMargin: 2
                TabButton { text: qsTr("Account") }
                TabButton { text: qsTr("Password") }
            }
        }
    }

    // ---- 全 token 编辑(当前模式)----
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: tokCol.implicitHeight + Theme.space4 * 2
        radius: Theme.radiusLg
        color: Theme.card
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing

        ColumnLayout {
            id: tokCol
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
            anchors.margins: Theme.space4
            spacing: Theme.space2

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: qsTr("Tokens — ") + (Theme.dark ? qsTr("dark") : qsTr("light")) + " mode"
                    color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium
                }
                Item { Layout.fillWidth: true }
                Text { text: qsTr("toggle mode from the top bar"); color: Theme.mutedForeground; font.pixelSize: 10 }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 20
                rowSpacing: 8
                Repeater {
                    model: Theme.colorTokenNames
                    delegate: RowLayout {
                        required property string modelData
                        Layout.fillWidth: true
                        spacing: 8
                        Rectangle {
                            width: 20; height: 20; radius: Theme.radiusSm
                            color: Theme.tokenColor(modelData)
                            border.width: 1; border.color: Theme.alpha(Theme.foreground, 0.15)
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData
                            color: Theme.foreground; font.pixelSize: Theme.textXs
                            elide: Text.ElideRight
                        }
                        Input {
                            Layout.preferredWidth: 96
                            text: page.toHex(Theme.tokenColor(modelData))
                            font.family: Theme.fontMono
                            onEditingFinished: {
                                if (page._hexRe.test(text)) Theme.setToken(modelData, text, Theme.dark)
                            }
                        }
                    }
                }
            }
        }
    }

    // ---- 导出配置 + 重置 ----
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: expCol.implicitHeight + Theme.space4 * 2
        radius: Theme.radiusLg
        color: Theme.muted
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing

        ColumnLayout {
            id: expCol
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
            anchors.margins: Theme.space4
            spacing: Theme.space2

            RowLayout {
                Layout.fillWidth: true
                Text { text: qsTr("Export"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                Item { Layout.fillWidth: true }
                Button { text: qsTr("Reset"); size: Button.Sm; variant: Button.Outline; onClicked: Theme.resetTheme() }
            }
            Text {
                Layout.fillWidth: true
                // 依赖 overrides/radius 变化即刷新
                text: (Theme.lightOverrides, Theme.darkOverrides, Theme.radiusOverride, Theme.exportJson())
                color: Theme.foreground
                font.family: Theme.fontMono
                font.pixelSize: Theme.textXs
                lineHeight: 1.5
                lineHeightMode: Text.ProportionalHeight
                textFormat: Text.PlainText
                wrapMode: Text.Wrap
            }
        }
    }
}
