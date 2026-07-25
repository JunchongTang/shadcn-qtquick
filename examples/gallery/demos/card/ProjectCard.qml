import QtQuick
import QtQuick.Layouts
import Shadcn

Card {
    width: 340
    CardHeader {
        CardTitle { text: qsTr("Create project") }
        CardDescription { text: qsTr("Deploy your new project in one-click.") }
    }
    CardContent {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            Label { text: qsTr("Name") }
            Input { Layout.fillWidth: true; placeholderText: qsTr("Name of your project") }
        }
    }
    CardFooter {
        Button { text: qsTr("Cancel"); variant: Button.Outline }
        Item { Layout.fillWidth: true }
        Button { text: qsTr("Deploy") }
    }
}
