import QtQuick
import Shadcn

// 官方 Invalid:aria-invalid → 破坏色边框 + 破坏色环。
Combobox {
    width: 220
    invalid: true
    placeholder: "Select a framework"
    emptyText: "No items found."
    model: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
}
