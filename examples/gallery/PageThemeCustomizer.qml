import QtQuick
import QtQuick.Layouts
import Shadcn

// 主题定制器 —— 对标 ui.shadcn.com/create 的双栏体验:
//   左侧:实时组件 showcase(全库随主题即时变样);
//   右侧:浮动定制面板(base color 色系 / accent 强调色 / radius / 明暗 / 随机 / 重置 / 复制)。
// 全部通过 Theme 的覆盖层(setToken/setRadius/resetTheme/exportJson)驱动。Web 专属能力
// (v0、Get Code、分享链接、preset API、样式/图标/字体库选择器)在桌面库中不适用,故略去。
Item {
    id: page

    // 由 gallery 传入的可用视口高度(见 Gallery.qml 的 pageLoader.onLoaded)。
    property real viewportHeight: 600
    implicitHeight: viewportHeight

    // ==== base color 色系:设置中性色板(明/暗)。card/popover=bg,secondary/accent=muted,input=border ====
    readonly property var baseColors: [
        { name: "Neutral", dot: "#737373",
          l: { bg: "#ffffff", fg: "#0a0a0a", muted: "#f5f5f5", mutedFg: "#737373", border: "#e5e5e5", ring: "#a1a1a1" },
          d: { bg: "#0a0a0a", fg: "#fafafa", muted: "#262626", mutedFg: "#a1a1a1", border: "#2a2a2a", ring: "#737373" } },
        { name: "Stone", dot: "#78716c",
          l: { bg: "#ffffff", fg: "#1c1917", muted: "#f5f5f4", mutedFg: "#78716c", border: "#e7e5e4", ring: "#a8a29e" },
          d: { bg: "#0c0a09", fg: "#fafaf9", muted: "#292524", mutedFg: "#a8a29e", border: "#292524", ring: "#78716c" } },
        { name: "Zinc", dot: "#71717a",
          l: { bg: "#ffffff", fg: "#18181b", muted: "#f4f4f5", mutedFg: "#71717a", border: "#e4e4e7", ring: "#a1a1aa" },
          d: { bg: "#09090b", fg: "#fafafa", muted: "#27272a", mutedFg: "#a1a1aa", border: "#27272a", ring: "#71717a" } },
        { name: "Slate", dot: "#64748b",
          l: { bg: "#ffffff", fg: "#0f172a", muted: "#f1f5f9", mutedFg: "#64748b", border: "#e2e8f0", ring: "#94a3b8" },
          d: { bg: "#020817", fg: "#f8fafc", muted: "#1e293b", mutedFg: "#94a3b8", border: "#1e293b", ring: "#64748b" } },
        { name: "Gray", dot: "#6b7280",
          l: { bg: "#ffffff", fg: "#111827", muted: "#f3f4f6", mutedFg: "#6b7280", border: "#e5e7eb", ring: "#9ca3af" },
          d: { bg: "#030712", fg: "#f9fafb", muted: "#1f2937", mutedFg: "#9ca3af", border: "#1f2937", ring: "#6b7280" } }
    ]

    // ==== accent 强调色:设置 primary + primaryForeground(明/暗)====
    readonly property var accents: [
        { name: "Amber",  dot: "#f0b100", lp: "#fdc700", lf: "#733e0a", dp: "#f0b100", df: "#733e0a" },
        { name: "Blue",   dot: "#3b82f6", lp: "#2563eb", lf: "#ffffff", dp: "#3b82f6", df: "#ffffff" },
        { name: "Green",  dot: "#10b981", lp: "#059669", lf: "#ffffff", dp: "#10b981", df: "#052e16" },
        { name: "Rose",   dot: "#f43f5e", lp: "#e11d48", lf: "#ffffff", dp: "#f43f5e", df: "#4c0519" },
        { name: "Violet", dot: "#8b5cf6", lp: "#7c3aed", lf: "#ffffff", dp: "#8b5cf6", df: "#ffffff" },
        { name: "Orange", dot: "#f97316", lp: "#ea580c", lf: "#ffffff", dp: "#f97316", df: "#431407" },
        { name: "Mono",   dot: "#171717", lp: "#171717", lf: "#fafafa", dp: "#fafafa", df: "#171717" }
    ]
    readonly property var radii: [0, 4, 8, 10, 14, 16]

    function applyBase(b) {
        var map = { "background": b.l.bg, "foreground": b.l.fg, "card": b.l.bg, "cardForeground": b.l.fg,
                    "popover": b.l.bg, "popoverForeground": b.l.fg, "secondary": b.l.muted, "secondaryForeground": b.l.fg,
                    "muted": b.l.muted, "mutedForeground": b.l.mutedFg, "accent": b.l.muted, "accentForeground": b.l.fg,
                    "border": b.l.border, "input": b.l.border, "ring": b.l.ring }
        for (var k in map) Theme.setToken(k, map[k], false)
        var dmap = { "background": b.d.bg, "foreground": b.d.fg, "card": b.d.bg, "cardForeground": b.d.fg,
                     "popover": b.d.bg, "popoverForeground": b.d.fg, "secondary": b.d.muted, "secondaryForeground": b.d.fg,
                     "muted": b.d.muted, "mutedForeground": b.d.mutedFg, "accent": b.d.muted, "accentForeground": b.d.fg,
                     "border": b.d.border, "input": b.d.border, "ring": b.d.ring }
        for (var dk in dmap) Theme.setToken(dk, dmap[dk], true)
    }
    function applyAccent(a) {
        Theme.setToken("primary", a.lp, false); Theme.setToken("primaryForeground", a.lf, false)
        Theme.setToken("primary", a.dp, true);  Theme.setToken("primaryForeground", a.df, true)
    }
    function randomize() {
        applyBase(baseColors[Math.floor(Math.random() * baseColors.length)])
        applyAccent(accents[Math.floor(Math.random() * accents.length)])
        Theme.setRadius(radii[Math.floor(Math.random() * radii.length)])
    }

    RowLayout {
        anchors.fill: parent
        spacing: 16

        // ============================ 左:实时 showcase ============================
        ScrollView {
            id: showcaseScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: showcaseScroll.availableWidth
                spacing: 16

                Text {
                    text: qsTr("Live preview")
                    color: Theme.foreground
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                }

                // ---- 按钮变体 ----
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Button { text: qsTr("Primary") }
                    Button { text: qsTr("Secondary"); variant: Button.Secondary }
                    Button { text: qsTr("Outline"); variant: Button.Outline }
                    Button { text: qsTr("Ghost"); variant: Button.Ghost }
                    Button { text: qsTr("Destructive"); variant: Button.Destructive }
                    Button { text: qsTr("Link"); variant: Button.Link }
                    Badge { text: qsTr("Badge") }
                    Badge { text: qsTr("Secondary"); variant: Badge.Secondary }
                }

                // ---- 卡片 + 表单 ----
                Card {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 520
                    CardHeader {
                        CardTitle { text: qsTr("Create account") }
                        CardDescription { text: qsTr("Enter your details below to create your account.") }
                    }
                    CardContent {
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Email") }
                                Input { Layout.fillWidth: true; placeholderText: qsTr("m@example.com") }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                Switch { checked: true }
                                Label { text: qsTr("Email me about updates") }
                                Item { Layout.fillWidth: true }
                                Checkbox { text: qsTr("Remember"); checked: true }
                            }
                            Slider { Layout.fillWidth: true; value: 60 }
                            Progress { Layout.fillWidth: true; value: 60 }
                        }
                    }
                    CardFooter {
                        Button { text: qsTr("Cancel"); variant: Button.Outline }
                        Item { Layout.fillWidth: true }
                        Button { text: qsTr("Create") }
                    }
                }

                // ---- Tabs ----
                Tabs {
                    Layout.topMargin: 2
                    TabButton { text: qsTr("Account") }
                    TabButton { text: qsTr("Password") }
                    TabButton { text: qsTr("Settings") }
                }

                // ---- Alert ----
                Alert {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 520
                    iconName: "circle-check"
                    title: qsTr("Heads up!")
                    description: qsTr("Every component on this page re-themes as you tweak the panel.")
                }

                Item { Layout.fillHeight: true }   // 底部留白
            }
        }

        // ============================ 右:定制面板 ============================
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            radius: Theme.radiusLg
            color: Theme.card
            border.width: Theme.overlayRingWidth
            border.color: Theme.overlayRing

            ScrollView {
                id: panelScroll
                anchors.fill: parent
                anchors.margins: 16
                clip: true
                contentWidth: availableWidth

                ColumnLayout {
                    width: panelScroll.availableWidth
                    spacing: 16

                    Text { text: qsTr("Customize"); color: Theme.foreground; font.pixelSize: Theme.textBase; font.weight: Font.DemiBold }

                    // ---- Base color ----
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Text { text: qsTr("Base color"); color: Theme.foreground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                        Flow {
                            Layout.fillWidth: true
                            spacing: 6
                            Repeater {
                                model: page.baseColors
                                delegate: Button {
                                    required property var modelData
                                    text: modelData.name
                                    size: Button.Sm
                                    variant: Button.Outline
                                    leftPadding: 24
                                    onClicked: page.applyBase(modelData)
                                    Rectangle {
                                        x: 8; anchors.verticalCenter: parent.verticalCenter
                                        width: 11; height: 11; radius: 6
                                        color: parent.modelData.dot
                                        border.width: 1; border.color: Theme.alpha(Theme.foreground, 0.15)
                                    }
                                }
                            }
                        }
                    }

                    // ---- Accent ----
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Text { text: qsTr("Accent color"); color: Theme.foreground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                        Flow {
                            Layout.fillWidth: true
                            spacing: 6
                            Repeater {
                                model: page.accents
                                delegate: Button {
                                    required property var modelData
                                    text: modelData.name
                                    size: Button.Sm
                                    variant: Button.Outline
                                    leftPadding: 24
                                    onClicked: page.applyAccent(modelData)
                                    Rectangle {
                                        x: 8; anchors.verticalCenter: parent.verticalCenter
                                        width: 11; height: 11; radius: 6
                                        color: parent.modelData.dot
                                        border.width: 1; border.color: Theme.alpha(Theme.foreground, 0.15)
                                    }
                                }
                            }
                        }
                    }

                    // ---- Radius ----
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Text { text: qsTr("Radius"); color: Theme.foreground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                        Flow {
                            Layout.fillWidth: true
                            spacing: 6
                            Repeater {
                                model: page.radii
                                delegate: Button {
                                    required property var modelData
                                    text: modelData
                                    size: Button.Sm
                                    variant: (Theme.radiusOverride < 0 ? 10 : Theme.radiusOverride) === modelData ? Button.Default : Button.Outline
                                    onClicked: Theme.setRadius(modelData)
                                }
                            }
                        }
                    }

                    // ---- Mode ----
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Text { text: qsTr("Mode"); color: Theme.foreground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                        RowLayout {
                            spacing: 6
                            Button { text: qsTr("Light"); size: Button.Sm; variant: Theme.dark ? Button.Outline : Button.Default; onClicked: Theme.dark = false }
                            Button { text: qsTr("Dark"); size: Button.Sm; variant: Theme.dark ? Button.Default : Button.Outline; onClicked: Theme.dark = true }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.border }

                    // ---- Actions ----
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Button {
                            Layout.fillWidth: true
                            text: qsTr("Randomize")
                            size: Button.Sm
                            iconName: "shuffle"
                            onClicked: page.randomize()
                        }
                        Button {
                            id: copyBtn
                            Layout.fillWidth: true
                            text: copyBtn._done ? qsTr("Copied!") : qsTr("Copy theme")
                            size: Button.Sm
                            variant: Button.Secondary
                            iconName: copyBtn._done ? "check" : "copy"
                            property bool _done: false
                            onClicked: {
                                SourceReader.copyToClipboard(Theme.exportJson())
                                copyBtn._done = true
                                copyTimer.restart()
                            }
                            Timer { id: copyTimer; interval: 1200; onTriggered: copyBtn._done = false }
                        }
                        Button {
                            Layout.fillWidth: true
                            text: qsTr("Reset")
                            size: Button.Sm
                            variant: Button.Ghost
                            iconName: "rotate-ccw"
                            onClicked: Theme.resetTheme()
                        }
                    }
                }
            }
        }
    }
}
