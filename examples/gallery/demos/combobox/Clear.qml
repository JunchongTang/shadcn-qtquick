import QtQuick
import Shadcn

// Official Clear Button: ComboboxInput showClear + preselected value → shows a clear × button.
Combobox {
    width: 220
    placeholder: qsTr("Select a framework")
    emptyText: qsTr("No items found.")
    showClear: true
    currentValue: "Next.js"
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
