import QtQuick

PageScaffold {
    description: "An image element with a fallback for representing the user."

    ExampleCard {
        title: "Basic"
        source: "qrc:/demos/avatar/Basic.qml"
    }
    ExampleCard {
        title: "Sizes"
        description: "Small, default and large sizes."
        source: "qrc:/demos/avatar/Sizes.qml"
    }
    ExampleCard {
        title: "Avatar Group"
        description: "Overlapping avatars with a background ring."
        source: "qrc:/demos/avatar/Group.qml"
    }
    ExampleCard {
        title: "Avatar Group Count"
        description: "Append a count to indicate additional members."
        source: "qrc:/demos/avatar/GroupCount.qml"
    }
}
