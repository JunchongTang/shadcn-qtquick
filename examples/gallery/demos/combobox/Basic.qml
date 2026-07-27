import QtQuick
import Shadcn

// Official combobox-basic: editable input selecting a framework (type to filter).
Combobox {
    width: 220
    placeholder: qsTr("Select a framework")
    emptyText: qsTr("No items found.")
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
