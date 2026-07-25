import QtQuick

PageScaffold {
    description: "Combine labels, controls, and help text to compose accessible form fields and grouped inputs."

    ExampleCard {
        title: "Field"
        description: "A complete form composed with FieldSet, FieldGroup, FieldSeparator and mixed field orientations."
        source: "qrc:/demos/field/Demo.qml"
        previewMinHeight: 640
    }
    ExampleCard {
        title: "Input"
        description: "Stack a label, input and description vertically. The order of children is free."
        source: "qrc:/demos/field/Input.qml"
    }
    ExampleCard {
        title: "Textarea"
        description: "Pair a textarea with a label and supporting description."
        source: "qrc:/demos/field/Textarea.qml"
    }
    ExampleCard {
        title: "Select"
        description: "A single field wrapping a select with a helper description."
        source: "qrc:/demos/field/Select.qml"
    }
    ExampleCard {
        title: "Slider"
        description: "Use FieldTitle with a slider and a description that reflects the value."
        source: "qrc:/demos/field/Slider.qml"
    }
    ExampleCard {
        title: "Fieldset"
        description: "Group related fields under a legend, with a two-column row inside."
        source: "qrc:/demos/field/Fieldset.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Checkbox"
        description: "Horizontal checkbox fields, a separator, and a checkbox paired with FieldContent."
        source: "qrc:/demos/field/Checkbox.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: "Radio"
        description: "A radio group of horizontal fields under a label-variant legend."
        source: "qrc:/demos/field/Radio.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Switch"
        description: "A compact horizontal field: label on the left, switch on the right."
        source: "qrc:/demos/field/Switch.qml"
    }
    ExampleCard {
        title: "Choice Card"
        description: "Wrap fields in bordered, selectable cards. Works with radio, checkbox or switch."
        source: "qrc:/demos/field/ChoiceCard.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Field Group"
        description: "Stack fields with FieldGroup and divide sections with FieldSeparator."
        source: "qrc:/demos/field/Group.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: "Responsive Layout"
        description: "Responsive orientation (simplified to horizontal): content on the left, control on the right."
        source: "qrc:/demos/field/Responsive.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Validation and Errors"
        description: "Mark a field invalid to color its text, flag the control, and show FieldError."
        source: "qrc:/demos/field/Validation.qml"
        previewMinHeight: 240
    }
}
