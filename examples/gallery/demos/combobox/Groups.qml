import QtQuick
import Shadcn

// Official Groups: group headers + separators between groups; typing keeps only groups with matches.
Combobox {
    width: 240
    placeholder: qsTr("Select a timezone")
    emptyText: qsTr("No timezones found.")
    model: [
        { header: qsTr("Americas") },
        "(GMT-5) New York", "(GMT-8) Los Angeles", "(GMT-6) Chicago",
        "(GMT-5) Toronto", "(GMT-8) Vancouver", "(GMT-3) São Paulo",
        { separator: true },
        { header: qsTr("Europe") },
        "(GMT+0) London", "(GMT+1) Paris", "(GMT+1) Berlin",
        "(GMT+1) Rome", "(GMT+1) Madrid", "(GMT+1) Amsterdam",
        { separator: true },
        { header: qsTr("Asia/Pacific") },
        "(GMT+9) Tokyo", "(GMT+8) Shanghai", "(GMT+8) Singapore",
        "(GMT+4) Dubai", "(GMT+11) Sydney", "(GMT+9) Seoul"
    ]
}
