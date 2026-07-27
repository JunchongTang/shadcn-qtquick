import QtQuick
import QtQuick.Layouts
import Shadcn

// Single vertical Field: label + Select + description.
Field {
    width: 280        // max-w-xs

    FieldLabel { text: qsTr("Department") }
    Select {
        Layout.fillWidth: true
        currentIndex: -1
        placeholder: qsTr("Choose department")
        model: [
            qsTr("Engineering"), qsTr("Design"), qsTr("Marketing"), qsTr("Sales"),
            qsTr("Customer Support"), qsTr("Human Resources"), qsTr("Finance"), qsTr("Operations")
        ]
    }
    FieldDescription { text: qsTr("Select your department or area of work.") }
}
