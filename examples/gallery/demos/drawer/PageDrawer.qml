import QtQuick

PageScaffold {
    description: qsTr("A panel that slides in from the edge of the screen. Defaults to the bottom.")

    ExampleCard {
        title: qsTr("Drawer")
        description: qsTr("The \"Move Goal\" demo: a bottom drawer with a grab handle, a goal stepper, an activity chart and a footer.")
        source: "qrc:/demos/drawer/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Directions")
        description: qsTr("A drawer can slide in from any edge — top, right, bottom or left.")
        source: "qrc:/demos/drawer/Directions.qml"
    }
    ExampleCard {
        title: qsTr("Swipe Handle")
        description: qsTr("A bottom drawer that shows the centered grab handle.")
        source: "qrc:/demos/drawer/Handle.qml"
    }
    ExampleCard {
        title: qsTr("Nested")
        description: qsTr("Open a drawer from within another drawer; the parent stays mounted behind it.")
        source: "qrc:/demos/drawer/Nested.qml"
    }
    ExampleCard {
        title: qsTr("Non Modal")
        description: qsTr("The drawer does not dim or block the page, so the content behind stays interactive.")
        source: "qrc:/demos/drawer/NonModal.qml"
    }
    ExampleCard {
        title: qsTr("Responsive Dialog")
        description: qsTr("Presented as a centered dialog on wide viewports and a bottom drawer on narrow ones.")
        source: "qrc:/demos/drawer/ResponsiveDialog.qml"
    }
    // Skipped official section:
    //   · Snap Points — the Qt Quick Controls Drawer has no native snap-point support
    //     (it either opens fully or is dragged closed); omitted rather than faked.
}
