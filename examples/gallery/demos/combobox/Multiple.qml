import QtQuick
import Shadcn

// 官方 Multiple:chips 容器 + 内联输入过滤;下拉项左侧勾选;预选 Next.js。
Combobox {
    width: 260
    multiple: true
    placeholder: "Select frameworks..."
    emptyText: "No items found."
    selectedValues: ["Next.js"]
    model: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
}
