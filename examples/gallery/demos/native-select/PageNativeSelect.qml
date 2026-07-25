import QtQuick

PageScaffold {
    description: qsTr("A styled native select element with consistent design system integration.")

    ExampleCard {
        title: qsTr("Native Select")
        source: "qrc:/demos/native-select/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Sizes")
        source: "qrc:/demos/native-select/Sizes.qml"
    }
    ExampleCard {
        title: qsTr("Groups")
        source: "qrc:/demos/native-select/Groups.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        source: "qrc:/demos/native-select/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        source: "qrc:/demos/native-select/Invalid.qml"
    }
}
