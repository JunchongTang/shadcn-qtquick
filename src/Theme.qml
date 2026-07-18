pragma Singleton
import QtQuick

// shadcn 设计令牌(base-mira · neutral · amber),与前端 prototype/app/globals.css 一一对应,
// 不做删减。oklch → sRGB 精确转换(见 scratchpad/oklch_all.mjs)。切换明/暗只需设 Theme.dark。
QtObject {
    id: theme

    property bool dark: false

    // ==== 颜色令牌(globals.css :root / .dark 全量)========================
    readonly property color background: dark ? "#0a0a0a" : "#ffffff"
    readonly property color foreground: dark ? "#fafafa" : "#0a0a0a"
    readonly property color card: dark ? "#171717" : "#ffffff"
    readonly property color cardForeground: dark ? "#fafafa" : "#0a0a0a"
    readonly property color popover: dark ? "#171717" : "#ffffff"
    readonly property color popoverForeground: dark ? "#fafafa" : "#0a0a0a"
    readonly property color primary: dark ? "#f0b100" : "#fdc700"
    readonly property color primaryForeground: dark ? "#733e0a" : "#733e0a"
    readonly property color secondary: dark ? "#27272a" : "#f4f4f5"
    readonly property color secondaryForeground: dark ? "#fafafa" : "#18181b"
    readonly property color muted: dark ? "#262626" : "#f5f5f5"
    readonly property color mutedForeground: dark ? "#a1a1a1" : "#737373"
    readonly property color accent: dark ? "#262626" : "#f5f5f5"
    readonly property color accentForeground: dark ? "#fafafa" : "#171717"
    readonly property color destructive: dark ? "#ff6467" : "#e7000b"
    readonly property color border: dark ? "#1affffff" : "#e5e5e5"
    readonly property color input: dark ? "#26ffffff" : "#e5e5e5"
    readonly property color ring: dark ? "#737373" : "#a1a1a1"
    readonly property color chart1: dark ? "#ffd230" : "#ffd230"
    readonly property color chart2: dark ? "#fe9a00" : "#fe9a00"
    readonly property color chart3: dark ? "#e17100" : "#e17100"
    readonly property color chart4: dark ? "#bb4d00" : "#bb4d00"
    readonly property color chart5: dark ? "#973c00" : "#973c00"
    readonly property color sidebar: dark ? "#171717" : "#fafafa"
    readonly property color sidebarForeground: dark ? "#fafafa" : "#0a0a0a"
    readonly property color sidebarPrimary: dark ? "#f0b100" : "#d08700"
    readonly property color sidebarPrimaryForeground: dark ? "#fefce8" : "#fefce8"
    readonly property color sidebarAccent: dark ? "#262626" : "#f5f5f5"
    readonly property color sidebarAccentForeground: dark ? "#fafafa" : "#171717"
    readonly property color sidebarBorder: dark ? "#1affffff" : "#e5e5e5"
    readonly property color sidebarRing: dark ? "#737373" : "#a1a1a1"

    // ==== 圆角(--radius 0.45rem;阶梯按 globals.css @theme inline 的倍率派生)===
    readonly property real radius: 7.2               // 0.45rem × 16
    readonly property real radiusSm: radius * 0.6    // 4.32
    readonly property real radiusMd: radius * 0.8    // 5.76
    readonly property real radiusLg: radius          // 7.2
    readonly property real radiusXl: radius * 1.4    // 10.08
    readonly property real radius2xl: radius * 1.8   // 12.96
    readonly property real radius3xl: radius * 2.2   // 15.84
    readonly property real radius4xl: radius * 2.6   // 18.72

    // ==== 字体(--font-sans / --font-mono / --font-heading)==================
    readonly property string fontSans: "Inter"       // 前端 next/font Inter,缺失时系统回退
    readonly property string fontMono: "Geist Mono"
    readonly property string fontHeading: fontSans

    // ==== 焦点环(focus-visible:ring-[3px] ring-ring/…;非 CSS 变量,固化在此)==
    readonly property real ringWidth: 3
    readonly property real ringOpacity: dark ? 0.4 : 0.5

    // ==== 附加(非 shadcn CSS 变量,QML 侧便利令牌)========================
    // Tailwind 间距刻度(rem × 4 → px),组件内边距/间距用。
    readonly property real space1: 4
    readonly property real space1_5: 6
    readonly property real space2: 8
    readonly property real space2_5: 10
    readonly property real space3: 12
    readonly property real space4: 16
    // 字号(Tailwind text-xs/sm/base)
    readonly property int textXs: 12
    readonly property int textSm: 13
    readonly property int textBase: 14
    // 动效
    readonly property int durFast: 120

    // 令牌色 × 不透明度(对标 CSS 的 color/NN)。
    function alpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }
}
