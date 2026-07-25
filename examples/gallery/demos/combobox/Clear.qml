import QtQuick
import Shadcn

// 官方 Clear Button:ComboboxInput showClear + 预选值 → 显示清除 × 按钮。
Combobox {
    width: 220
    placeholder: qsTr("Select a framework")
    emptyText: qsTr("No items found.")
    showClear: true
    currentValue: "Next.js"
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
