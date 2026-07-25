import QtQuick

PageScaffold {
    description: qsTr("Displays a list of options for the user to pick from — triggered by a button.")

    ExampleCard {
        title: qsTr("Select")
        source: "qrc:/demos/select/Basic.qml"
    }
    ExampleCard {
        title: qsTr("With label")
        source: "qrc:/demos/select/WithLabel.qml"
    }
    ExampleCard {
        title: qsTr("Groups")
        source: "qrc:/demos/select/Groups.qml"
    }
    ExampleCard {
        title: qsTr("Scrollable")
        source: "qrc:/demos/select/Scrollable.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        source: "qrc:/demos/select/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        source: "qrc:/demos/select/Invalid.qml"
    }
    ExampleCard {
        title: qsTr("Align Item With Trigger")
        source: "qrc:/demos/select/Align.qml"
    }
}
