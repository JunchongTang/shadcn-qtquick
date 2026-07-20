import QtQuick
import Shadcn

// 多项 + 分组:弹层高度上限 300,超出则列表滚动(ListView 自带滚动条)。
Select {
    width: 256
    textRole: "text"
    currentIndex: -1
    placeholder: "Select a timezone"
    model: [
        { header: "North America" },
        { text: "Eastern Standard Time" },
        { text: "Central Standard Time" },
        { text: "Mountain Standard Time" },
        { text: "Pacific Standard Time" },
        { text: "Alaska Standard Time" },
        { text: "Hawaii Standard Time" },
        { header: "Europe & Africa" },
        { text: "Greenwich Mean Time" },
        { text: "Central European Time" },
        { text: "Eastern European Time" },
        { text: "Western European Summer Time" },
        { text: "Central Africa Time" },
        { text: "East Africa Time" },
        { header: "Asia" },
        { text: "Moscow Time" },
        { text: "India Standard Time" },
        { text: "China Standard Time" },
        { text: "Japan Standard Time" },
        { text: "Korea Standard Time" },
        { text: "Indonesia Central Standard Time" },
        { header: "Australia & Pacific" },
        { text: "Australian Western Standard Time" },
        { text: "Australian Central Standard Time" },
        { text: "Australian Eastern Standard Time" },
        { text: "New Zealand Standard Time" },
        { text: "Fiji Time" },
        { header: "South America" },
        { text: "Argentina Time" },
        { text: "Bolivia Time" },
        { text: "Brasilia Time" },
        { text: "Chile Standard Time" }
    ]
}
