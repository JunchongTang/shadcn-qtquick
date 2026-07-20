import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-link-button:用 render 把标记变为链接或按钮。
//   链接:interactive + underline(常驻下划线,hover→foreground)。
//   按钮:interactive(hover→foreground,点击触发动作)。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    // render={<a href="#links-and-buttons" />}
    Marker {
        interactive: true
        underline: true
        iconName: "git-branch"
        text: "View the pull request"
        onClicked: console.log("navigate: #links-and-buttons")
    }
    // render={<button ... onClick={() => toast(...)} />}
    Marker {
        interactive: true
        iconName: "rotate-ccw"
        text: "Revert this change"
        onClicked: console.log("You clicked the revert button")
    }
}
