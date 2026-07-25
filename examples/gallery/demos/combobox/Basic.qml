import QtQuick
import Shadcn

// 官方 combobox-basic:可编辑输入框选择框架(打字过滤)。
Combobox {
    width: 220
    placeholder: qsTr("Select a framework")
    emptyText: qsTr("No items found.")
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
