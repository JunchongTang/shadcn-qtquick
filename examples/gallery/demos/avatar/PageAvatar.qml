import QtQuick

PageScaffold {
    description: qsTr("An image element with a fallback for representing the user.")

    ExampleCard {
        title: qsTr("Basic")
        source: "qrc:/demos/avatar/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Sizes")
        description: qsTr("Small, default and large sizes.")
        source: "qrc:/demos/avatar/Sizes.qml"
    }
    ExampleCard {
        title: qsTr("Avatar Group")
        description: qsTr("Overlapping avatars with a background ring.")
        source: "qrc:/demos/avatar/Group.qml"
    }
    ExampleCard {
        title: qsTr("Avatar Group Count")
        description: qsTr("Append a count to indicate additional members.")
        source: "qrc:/demos/avatar/GroupCount.qml"
    }
}
