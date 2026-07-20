import QtQuick
import Shadcn

// 官方 native-select-groups:optgroup 分组 —— model 中的 { header } 渲染为分组标题(不可选)。
NativeSelect {
    width: 200
    textRole: "text"
    currentIndex: -1
    placeholder: "Select department"
    model: [
        { header: "Engineering" },
        { text: "Frontend" },
        { text: "Backend" },
        { text: "DevOps" },
        { header: "Sales" },
        { text: "Sales Rep" },
        { text: "Account Manager" },
        { text: "Sales Director" },
        { header: "Operations" },
        { text: "Customer Support" },
        { text: "Product Manager" },
        { text: "Operations Manager" }
    ]
}
