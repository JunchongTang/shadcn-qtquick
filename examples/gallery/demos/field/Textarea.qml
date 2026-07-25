import QtQuick
import QtQuick.Layouts
import Shadcn

FieldSet {
    width: 280        // max-w-xs

    FieldGroup {
        Field {
            FieldLabel { text: qsTr("Feedback") }
            Textarea {
                Layout.fillWidth: true
                implicitHeight: 88
                placeholderText: qsTr("Your feedback helps us improve...")
            }
            FieldDescription { text: qsTr("Share your thoughts about our service.") }
        }
    }
}
