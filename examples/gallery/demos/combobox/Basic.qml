import QtQuick
import Shadcn

// 官方 combobox-basic:可编辑输入框选择框架(打字过滤)。
Combobox {
    width: 220
    placeholder: "Select a framework"
    emptyText: "No items found."
    model: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
}
