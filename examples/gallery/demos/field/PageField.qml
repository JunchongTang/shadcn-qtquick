import QtQuick

PageScaffold {
    description: qsTr("Combine labels, controls, and help text to compose accessible form fields and grouped inputs.")

    ExampleCard {
        title: qsTr("Field")
        description: qsTr("A complete form composed with FieldSet, FieldGroup, FieldSeparator and mixed field orientations.")
        source: "qrc:/demos/field/Demo.qml"
        previewMinHeight: 640
    }
    ExampleCard {
        title: qsTr("Input")
        description: qsTr("Stack a label, input and description vertically. The order of children is free.")
        source: "qrc:/demos/field/Input.qml"
    }
    ExampleCard {
        title: qsTr("Textarea")
        description: qsTr("Pair a textarea with a label and supporting description.")
        source: "qrc:/demos/field/Textarea.qml"
    }
    ExampleCard {
        title: qsTr("Select")
        description: qsTr("A single field wrapping a select with a helper description.")
        source: "qrc:/demos/field/Select.qml"
    }
    ExampleCard {
        title: qsTr("Slider")
        description: qsTr("Use FieldTitle with a slider and a description that reflects the value.")
        source: "qrc:/demos/field/Slider.qml"
    }
    ExampleCard {
        title: qsTr("Fieldset")
        description: qsTr("Group related fields under a legend, with a two-column row inside.")
        source: "qrc:/demos/field/Fieldset.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Checkbox")
        description: qsTr("Horizontal checkbox fields, a separator, and a checkbox paired with FieldContent.")
        source: "qrc:/demos/field/Checkbox.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: qsTr("Radio")
        description: qsTr("A radio group of horizontal fields under a label-variant legend.")
        source: "qrc:/demos/field/Radio.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Switch")
        description: qsTr("A compact horizontal field: label on the left, switch on the right.")
        source: "qrc:/demos/field/Switch.qml"
    }
    ExampleCard {
        title: qsTr("Choice Card")
        description: qsTr("Wrap fields in bordered, selectable cards. Works with radio, checkbox or switch.")
        source: "qrc:/demos/field/ChoiceCard.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Field Group")
        description: qsTr("Stack fields with FieldGroup and divide sections with FieldSeparator.")
        source: "qrc:/demos/field/Group.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("Responsive Layout")
        description: qsTr("Responsive orientation (simplified to horizontal): content on the left, control on the right.")
        source: "qrc:/demos/field/Responsive.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Validation and Errors")
        description: qsTr("Mark a field invalid to color its text, flag the control, and show FieldError.")
        source: "qrc:/demos/field/Validation.qml"
        previewMinHeight: 240
    }
}
