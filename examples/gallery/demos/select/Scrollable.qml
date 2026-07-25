import QtQuick
import Shadcn

// 多项 + 分组:弹层高度上限 300,超出则列表滚动(ListView 自带滚动条)。
Select {
    width: 256
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select a timezone")
    model: [
        { header: qsTr("North America") },
        { text: qsTr("Eastern Standard Time") },
        { text: qsTr("Central Standard Time") },
        { text: qsTr("Mountain Standard Time") },
        { text: qsTr("Pacific Standard Time") },
        { text: qsTr("Alaska Standard Time") },
        { text: qsTr("Hawaii Standard Time") },
        { header: qsTr("Europe & Africa") },
        { text: qsTr("Greenwich Mean Time") },
        { text: qsTr("Central European Time") },
        { text: qsTr("Eastern European Time") },
        { text: qsTr("Western European Summer Time") },
        { text: qsTr("Central Africa Time") },
        { text: qsTr("East Africa Time") },
        { header: qsTr("Asia") },
        { text: qsTr("Moscow Time") },
        { text: qsTr("India Standard Time") },
        { text: qsTr("China Standard Time") },
        { text: qsTr("Japan Standard Time") },
        { text: qsTr("Korea Standard Time") },
        { text: qsTr("Indonesia Central Standard Time") },
        { header: qsTr("Australia & Pacific") },
        { text: qsTr("Australian Western Standard Time") },
        { text: qsTr("Australian Central Standard Time") },
        { text: qsTr("Australian Eastern Standard Time") },
        { text: qsTr("New Zealand Standard Time") },
        { text: qsTr("Fiji Time") },
        { header: qsTr("South America") },
        { text: qsTr("Argentina Time") },
        { text: qsTr("Bolivia Time") },
        { text: qsTr("Brasilia Time") },
        { text: qsTr("Chile Standard Time") }
    ]
}
