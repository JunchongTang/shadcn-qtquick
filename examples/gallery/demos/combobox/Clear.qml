import QtQuick
import Shadcn

// 官方 Clear Button:ComboboxInput showClear + 预选值 → 显示清除 × 按钮。
Combobox {
    width: 220
    placeholder: "Select a framework"
    emptyText: "No items found."
    showClear: true
    currentValue: "Next.js"
    model: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
}
