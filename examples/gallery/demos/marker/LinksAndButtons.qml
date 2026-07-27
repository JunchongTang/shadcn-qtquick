import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-link-button: use render to turn a marker into a link or button.
//   Link: interactive + underline (persistent underline, hover→foreground).
//   Button: interactive (hover→foreground, click triggers an action).
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    // render={<a href="#links-and-buttons" />}
    Marker {
        interactive: true
        underline: true
        iconName: "git-branch"
        text: qsTr("View the pull request")
        onClicked: console.log("navigate: #links-and-buttons")
    }
    // render={<button ... onClick={() => toast(...)} />}
    Marker {
        interactive: true
        iconName: "rotate-ccw"
        text: qsTr("Revert this change")
        onClicked: console.log("You clicked the revert button")
    }
}
