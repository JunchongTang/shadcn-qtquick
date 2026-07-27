import QtQuick
import QtQuick.Layouts
import Shadcn

// Form: multi-field form (Name/Email/Phone/Country/Address + action buttons).
// Mirrors the web input-form: FieldGroup + two-column grid + Select.
ColumnLayout {
    width: 360
    spacing: 16

    // Name (required)
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 6
        RowLayout {
            spacing: 2
            Label { text: qsTr("Name") }
            Label { text: "*"; color: Theme.destructive }
        }
        Input { Layout.fillWidth: true; placeholderText: qsTr("Evil Rabbit") }
    }

    // Email + description
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 6
        Label { text: qsTr("Email") }
        Input { Layout.fillWidth: true; placeholderText: qsTr("john@example.com") }
        Text {
            Layout.fillWidth: true
            text: qsTr("We'll never share your email with anyone.")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
        }
    }

    // Phone / Country two columns
    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: 16
        rowSpacing: 6
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            Label { text: qsTr("Phone") }
            Input { Layout.fillWidth: true; placeholderText: "+1 (555) 123-4567" }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            Label { text: qsTr("Country") }
            Select {
                Layout.fillWidth: true
                model: [qsTr("United States"), qsTr("United Kingdom"), qsTr("Canada")]
            }
        }
    }

    // Address
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 6
        Label { text: qsTr("Address") }
        Input { Layout.fillWidth: true; placeholderText: qsTr("123 Main St") }
    }

    // Action buttons (horizontal)
    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 4
        spacing: 8
        Item { Layout.fillWidth: true }
        Button { text: qsTr("Cancel"); variant: Button.Outline }
        Button { text: qsTr("Submit") }
    }
}
