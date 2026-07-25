import QtQuick
import QtQuick.Layouts
import Shadcn

// 完整表单:Payment Method + Billing Address + Comments + 操作按钮。
// 综合演示 FieldSet/Legend/Description/Group/Separator/Field(纵横)/Content。
FieldGroup {
    width: 420        // max-w-md

    // ==== Payment Method ====
    FieldSet {
        FieldLegend { text: qsTr("Payment Method") }
        FieldDescription { text: qsTr("All transactions are secure and encrypted") }

        FieldGroup {
            Field {
                FieldLabel { text: qsTr("Name on Card") }
                Input {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Evil Rabbit")
                }
            }
            Field {
                FieldLabel { text: qsTr("Card Number") }
                Input {
                    Layout.fillWidth: true
                    placeholderText: "1234 5678 9012 3456"
                }
                FieldDescription { text: qsTr("Enter your 16-digit card number") }
            }

            // grid grid-cols-3 gap-4
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                columnSpacing: Theme.space4
                rowSpacing: Theme.space4

                Field {
                    FieldLabel { text: qsTr("Month") }
                    Select {
                        Layout.fillWidth: true
                        currentIndex: -1
                        placeholder: qsTr("MM")
                        model: ["01", "02", "03", "04", "05", "06",
                                "07", "08", "09", "10", "11", "12"]
                    }
                }
                Field {
                    FieldLabel { text: qsTr("Year") }
                    Select {
                        Layout.fillWidth: true
                        currentIndex: -1
                        placeholder: qsTr("YYYY")
                        model: ["2024", "2025", "2026", "2027", "2028", "2029"]
                    }
                }
                Field {
                    FieldLabel { text: qsTr("CVV") }
                    Input {
                        Layout.fillWidth: true
                        placeholderText: "123"
                    }
                }
            }
        }
    }

    FieldSeparator {}

    // ==== Billing Address ====
    FieldSet {
        FieldLegend { text: qsTr("Billing Address") }
        FieldDescription { text: qsTr("The billing address associated with your payment method") }

        FieldGroup {
            Field {
                orientation: Field.Horizontal
                Checkbox {
                    checked: true
                    Layout.alignment: Qt.AlignVCenter
                }
                FieldLabel {
                    text: qsTr("Same as shipping address")
                    font.weight: Font.Normal
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }

    // ==== Comments(无 Legend 的 FieldSet)====
    FieldSet {
        FieldGroup {
            Field {
                FieldLabel { text: qsTr("Comments") }
                Textarea {
                    Layout.fillWidth: true
                    implicitHeight: 72
                    placeholderText: qsTr("Add any additional comments")
                }
            }
        }
    }

    // ==== 操作按钮(横排)====
    Field {
        orientation: Field.Horizontal
        Button {
            text: qsTr("Submit")
            Layout.fillWidth: false
        }
        Button {
            text: qsTr("Cancel")
            variant: Button.Outline
            Layout.fillWidth: false
        }
        Item { Layout.fillWidth: true }
    }
}
