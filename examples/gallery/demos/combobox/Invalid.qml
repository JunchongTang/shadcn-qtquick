import QtQuick
import Shadcn

// Official Invalid: aria-invalid → destructive-colored border + destructive-colored ring.
Combobox {
    width: 220
    invalid: true
    placeholder: qsTr("Select a framework")
    emptyText: qsTr("No items found.")
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
