import QtQuick
import QtQuick.Layouts
import Shadcn

// FieldSet + FieldGroup:两个纵向 Field(标签/输入/描述)。
// 第二个字段刻意把描述放在输入之上,验证子项顺序自由。
FieldSet {
    width: 280        // max-w-xs

    FieldGroup {
        Field {
            FieldLabel { text: "Username" }
            Input {
                Layout.fillWidth: true
                text: "Max Leiter"
                placeholderText: "Max Leiter"
            }
            FieldDescription { text: "Choose a unique username for your account." }
        }
        Field {
            FieldLabel { text: "Password" }
            FieldDescription { text: "Must be at least 8 characters long." }
            Input {
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "••••••••"
            }
        }
    }
}
