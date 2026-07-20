import QtQuick
import Shadcn

// 官方 Disabled:整体禁用(输入框 opacity-50、不可编辑/展开)。
Combobox {
    width: 220
    enabled: false
    placeholder: "Select a framework"
    model: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
}
