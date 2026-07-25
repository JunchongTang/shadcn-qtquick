import QtQuick

PageScaffold {
    description: qsTr("Displays a file or image attachment with media, metadata, upload state, and actions.")

    ExampleCard {
        title: qsTr("Attachment")
        source: "qrc:/demos/attachment/Demo.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("Image")
        description: qsTr("Set variant=image on AttachmentMedia and use orientation=vertical to stack the media above the content.")
        source: "qrc:/demos/attachment/Image.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("States")
        description: qsTr("Set the state to reflect the upload lifecycle. Uploading and processing shimmer the title; error switches to a destructive treatment.")
        source: "qrc:/demos/attachment/States.qml"
        previewMinHeight: 340
    }
    ExampleCard {
        title: qsTr("Sizes")
        description: qsTr("Use the size property to switch between default, sm, and xs.")
        source: "qrc:/demos/attachment/Sizes.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Group")
        description: qsTr("Wrap attachments in AttachmentGroup to lay them out in a horizontally scrollable row.")
        source: "qrc:/demos/attachment/Group.qml"
        previewMinHeight: 160
    }
    ExampleCard {
        title: qsTr("Trigger")
        description: qsTr("Add an AttachmentTrigger to make the whole card open a link or dialog. It fills the card behind the actions, so the actions stay clickable.")
        source: "qrc:/demos/attachment/Trigger.qml"
        previewMinHeight: 160
    }
    ExampleCard {
        title: qsTr("Add / Drop Zone (approximation)")
        description: qsTr("An idle, dashed attachment with a full-card trigger approximates a click-to-add or drag-and-drop upload entry. Real file picking and drag-and-drop are not implemented.")
        source: "qrc:/demos/attachment/Add.qml"
        previewMinHeight: 160
    }
}
