import QtQuick
import Shadcn

// 官方 Custom Items:两行条目(标题 + 次级说明「大洲 (代码)」)。
Combobox {
    width: 260
    placeholder: "Search countries..."
    emptyText: "No countries found."
    model: [
        { value: "argentina",      label: "Argentina",      description: "South America (ar)" },
        { value: "australia",      label: "Australia",      description: "Oceania (au)" },
        { value: "brazil",         label: "Brazil",         description: "South America (br)" },
        { value: "canada",         label: "Canada",         description: "North America (ca)" },
        { value: "china",          label: "China",          description: "Asia (cn)" },
        { value: "colombia",       label: "Colombia",       description: "South America (co)" },
        { value: "egypt",          label: "Egypt",          description: "Africa (eg)" },
        { value: "france",         label: "France",         description: "Europe (fr)" },
        { value: "germany",        label: "Germany",        description: "Europe (de)" },
        { value: "italy",          label: "Italy",          description: "Europe (it)" },
        { value: "japan",          label: "Japan",          description: "Asia (jp)" },
        { value: "kenya",          label: "Kenya",          description: "Africa (ke)" },
        { value: "mexico",         label: "Mexico",         description: "North America (mx)" },
        { value: "new-zealand",    label: "New Zealand",    description: "Oceania (nz)" },
        { value: "nigeria",        label: "Nigeria",        description: "Africa (ng)" },
        { value: "south-africa",   label: "South Africa",   description: "Africa (za)" },
        { value: "south-korea",    label: "South Korea",    description: "Asia (kr)" },
        { value: "united-kingdom", label: "United Kingdom", description: "Europe (gb)" },
        { value: "united-states",  label: "United States",  description: "North America (us)" }
    ]
}
