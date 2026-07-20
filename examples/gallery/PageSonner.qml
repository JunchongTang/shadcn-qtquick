import QtQuick

PageScaffold {
    description: "An opinionated toast component. Click a trigger to pop a toast into the anchored area; it stacks, auto-dismisses, and slides in and out."

    ExampleCard {
        title: "Sonner"
        source: "qrc:/demos/sonner/Basic.qml"
    }
    ExampleCard {
        title: "Types"
        description: "Use default, success, info, warning and error toasts. base-mira does not enable rich colors, so the type only changes the leading icon."
        source: "qrc:/demos/sonner/Types.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Description"
        description: "Pair the toast title with a supporting description line."
        source: "qrc:/demos/sonner/Description.qml"
    }
    ExampleCard {
        title: "Action"
        description: "Add an action button to the toast; triggering it here pops a confirmation toast."
        source: "qrc:/demos/sonner/Action.qml"
    }
}
