import QtQuick
import Shadcn

// Official Multiple: chips container + inline input filtering; dropdown items check on the left; Next.js preselected.
Combobox {
    width: 260
    multiple: true
    placeholder: qsTr("Select frameworks...")
    emptyText: qsTr("No items found.")
    selectedValues: ["Next.js"]
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
