import QtQuick
import Shadcn

// 官方 Input Group:ComboboxInput 内嵌前置图标(globe)+ 分组时区列表。
Combobox {
    width: 240
    leadingIcon: "globe"
    placeholder: "Select a timezone"
    emptyText: "No timezones found."
    model: [
        { header: "Americas" },
        "(GMT-5) New York", "(GMT-8) Los Angeles", "(GMT-6) Chicago",
        "(GMT-5) Toronto", "(GMT-8) Vancouver", "(GMT-3) São Paulo",
        { separator: true },
        { header: "Europe" },
        "(GMT+0) London", "(GMT+1) Paris", "(GMT+1) Berlin",
        "(GMT+1) Rome", "(GMT+1) Madrid", "(GMT+1) Amsterdam",
        { separator: true },
        { header: "Asia/Pacific" },
        "(GMT+9) Tokyo", "(GMT+8) Shanghai", "(GMT+8) Singapore",
        "(GMT+4) Dubai", "(GMT+11) Sydney", "(GMT+9) Seoul"
    ]
}
