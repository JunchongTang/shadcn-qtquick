import QtQuick
import QtQuick.Layouts
import Shadcn

Card {
    width: 340
    CardHeader {
        CardTitle { text: "Create project" }
        CardDescription { text: "Deploy your new project in one-click." }
    }
    CardContent {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            Label { text: "Name" }
            Input { Layout.fillWidth: true; placeholderText: "Name of your project" }
        }
    }
    CardFooter {
        Button { text: "Cancel"; variant: Button.Outline }
        Item { Layout.fillWidth: true }
        Button { text: "Deploy" }
    }
}
