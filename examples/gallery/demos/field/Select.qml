import QtQuick
import QtQuick.Layouts
import Shadcn

// 单个纵向 Field:标签 + Select + 描述。
Field {
    width: 280        // max-w-xs

    FieldLabel { text: "Department" }
    Select {
        Layout.fillWidth: true
        currentIndex: -1
        placeholder: "Choose department"
        model: [
            "Engineering", "Design", "Marketing", "Sales",
            "Customer Support", "Human Resources", "Finance", "Operations"
        ]
    }
    FieldDescription { text: "Select your department or area of work." }
}
