import QtQuick
import Shadcn

// 官方 Invalid:aria-invalid → 破坏色边框 + 破坏色环。
Combobox {
    width: 220
    invalid: true
    placeholder: qsTr("Select a framework")
    emptyText: qsTr("No items found.")
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
