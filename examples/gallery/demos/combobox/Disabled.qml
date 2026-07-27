import QtQuick
import Shadcn

// Official Disabled: fully disabled (input opacity-50, not editable/expandable).
Combobox {
    width: 220
    enabled: false
    placeholder: qsTr("Select a framework")
    model: [qsTr("Next.js"), qsTr("SvelteKit"), qsTr("Nuxt.js"), qsTr("Remix"), qsTr("Astro")]
}
