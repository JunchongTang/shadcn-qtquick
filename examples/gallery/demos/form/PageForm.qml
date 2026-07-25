import QtQuick

PageScaffold {
    description: qsTr("Compose accessible form fields — label, control, description and validation errors — with FormField.")

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A single field: label, control and a muted description.")
        source: "qrc:/demos/form/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Controls")
        description: qsTr("FormField works with any control — input, textarea or select — and surfaces an error state.")
        source: "qrc:/demos/form/Controls.qml"
    }
    ExampleCard {
        title: qsTr("Validation")
        description: qsTr("A sign-up form. Submit to run lightweight validation and reveal per-field errors.")
        source: "qrc:/demos/form/SignUp.qml"
        previewMinHeight: 380
    }
}
