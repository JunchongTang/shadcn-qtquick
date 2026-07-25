import QtQuick
import Shadcn

// 官方 Multiple:chips 容器 + 内联输入过滤;下拉项左侧勾选;预选 Next.js。
Combobox {
    width: 260
    multiple: true
    placeholder: qsTr("Select frameworks...")
    emptyText: qsTr("No items found.")
    selectedValues: ["Next.js"]
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
