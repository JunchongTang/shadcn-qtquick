import QtQuick
import Shadcn

// Official Custom Items: two-line entries (title + secondary caption "continent (code)").
Combobox {
    width: 260
    placeholder: qsTr("Search countries...")
    emptyText: qsTr("No countries found.")
    model: [
        { value: "argentina",      label: qsTr("Argentina"),      description: qsTr("South America (ar)") },
        { value: "australia",      label: qsTr("Australia"),      description: qsTr("Oceania (au)") },
        { value: "brazil",         label: qsTr("Brazil"),         description: qsTr("South America (br)") },
        { value: "canada",         label: qsTr("Canada"),         description: qsTr("North America (ca)") },
        { value: "china",          label: qsTr("China"),          description: qsTr("Asia (cn)") },
        { value: "colombia",       label: qsTr("Colombia"),       description: qsTr("South America (co)") },
        { value: "egypt",          label: qsTr("Egypt"),          description: qsTr("Africa (eg)") },
        { value: "france",         label: qsTr("France"),         description: qsTr("Europe (fr)") },
        { value: "germany",        label: qsTr("Germany"),        description: qsTr("Europe (de)") },
        { value: "italy",          label: qsTr("Italy"),          description: qsTr("Europe (it)") },
        { value: "japan",          label: qsTr("Japan"),          description: qsTr("Asia (jp)") },
        { value: "kenya",          label: qsTr("Kenya"),          description: qsTr("Africa (ke)") },
        { value: "mexico",         label: qsTr("Mexico"),         description: qsTr("North America (mx)") },
        { value: "new-zealand",    label: qsTr("New Zealand"),    description: qsTr("Oceania (nz)") },
        { value: "nigeria",        label: qsTr("Nigeria"),        description: qsTr("Africa (ng)") },
        { value: "south-africa",   label: qsTr("South Africa"),   description: qsTr("Africa (za)") },
        { value: "south-korea",    label: qsTr("South Korea"),    description: qsTr("Asia (kr)") },
        { value: "united-kingdom", label: qsTr("United Kingdom"), description: qsTr("Europe (gb)") },
        { value: "united-states",  label: qsTr("United States"),  description: qsTr("North America (us)") }
    ]
}
