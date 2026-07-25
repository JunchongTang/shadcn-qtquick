import QtQuick
import Shadcn

// 官方 Disabled:整体禁用(输入框 opacity-50、不可编辑/展开)。
Combobox {
    width: 220
    enabled: false
    placeholder: qsTr("Select a framework")
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
