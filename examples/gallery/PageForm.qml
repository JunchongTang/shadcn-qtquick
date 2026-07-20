import QtQuick

PageScaffold {
    description: "Compose accessible form fields — label, control, description and validation errors — with FormField."

    ExampleCard {
        title: "Basic"
        description: "A single field: label, control and a muted description."
        source: "qrc:/demos/form/Basic.qml"
    }
    ExampleCard {
        title: "Controls"
        description: "FormField works with any control — input, textarea or select — and surfaces an error state."
        source: "qrc:/demos/form/Controls.qml"
    }
    ExampleCard {
        title: "Validation"
        description: "A sign-up form. Submit to run lightweight validation and reveal per-field errors."
        source: "qrc:/demos/form/SignUp.qml"
        previewMinHeight: 380
    }
}
