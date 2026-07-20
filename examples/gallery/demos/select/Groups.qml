import QtQuick
import Shadcn

// 分组:model 中的 { header } 渲染为分组标题,{ separator: true } 渲染为分隔线。
Select {
    width: 200
    textRole: "text"
    currentIndex: -1
    placeholder: "Select a fruit"
    model: [
        { header: "Fruits" },
        { text: "Apple" },
        { text: "Banana" },
        { text: "Blueberry" },
        { separator: true },
        { header: "Vegetables" },
        { text: "Carrot" },
        { text: "Broccoli" },
        { text: "Spinach" }
    ]
}
