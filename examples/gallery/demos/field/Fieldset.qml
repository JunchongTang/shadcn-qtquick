import QtQuick
import QtQuick.Layouts
import Shadcn

// FieldSet + Legend + Description + FieldGroup,其中一行用 GridLayout 两列并排(City / Postal)。
FieldSet {
    width: 320        // max-w-sm

    FieldLegend { text: "Address Information" }
    FieldDescription { text: "We need your address to deliver your order." }

    FieldGroup {
        Field {
            FieldLabel { text: "Street Address" }
            Input {
                Layout.fillWidth: true
                placeholderText: "123 Main St"
            }
        }
        // grid grid-cols-2 gap-4
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: Theme.space4
            rowSpacing: Theme.space4

            Field {
                FieldLabel { text: "City" }
                Input {
                    Layout.fillWidth: true
                    placeholderText: "New York"
                }
            }
            Field {
                FieldLabel { text: "Postal Code" }
                Input {
                    Layout.fillWidth: true
                    placeholderText: "90502"
                }
            }
        }
    }
}
