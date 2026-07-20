import QtQuick
import QtQuick.Layouts
import Shadcn

FieldSet {
    width: 280        // max-w-xs

    FieldGroup {
        Field {
            FieldLabel { text: "Feedback" }
            Textarea {
                Layout.fillWidth: true
                implicitHeight: 88
                placeholderText: "Your feedback helps us improve..."
            }
            FieldDescription { text: "Share your thoughts about our service." }
        }
    }
}
