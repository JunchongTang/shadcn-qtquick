import QtQuick

// Message 详情页。基础版:头像/分组/头脚/操作/附件/对齐。
// 未实现:富文本 markdown、气泡尾巴、反应表情、完整 Attachment、独立 MessageGroup 组件。
PageScaffold {
    description: qsTr("Displays a message in a conversation, with optional avatar, header, footer, and alignment. Basic QML port — rich text/markdown, bubble tails, reactions, and the full Attachment component are not implemented.")

    ExampleCard {
        title: qsTr("Message")
        source: "qrc:/demos/message/Demo.qml"
        previewMinHeight: 380
    }
    ExampleCard {
        title: qsTr("Avatar")
        description: qsTr("Use MessageAvatar to render an avatar next to the message. Set align=end to align it to the end.")
        source: "qrc:/demos/message/Avatar.qml"
        previewMinHeight: 300
    }
    ExampleCard {
        title: qsTr("Group")
        description: qsTr("Stack consecutive messages from the same sender. Earlier messages use an empty avatar to stay aligned.")
        source: "qrc:/demos/message/Group.qml"
    }
    ExampleCard {
        title: qsTr("Header and Footer")
        description: qsTr("MessageHeader for a sender name; MessageFooter for status such as delivered or read.")
        source: "qrc:/demos/message/HeaderFooter.qml"
    }
    ExampleCard {
        title: qsTr("Actions")
        description: qsTr("Message-level actions such as copy, retry, or feedback in the footer. Actions fade in on hover by default.")
        source: "qrc:/demos/message/Actions.qml"
    }
    ExampleCard {
        title: qsTr("Attachment")
        description: qsTr("Image cover above the bubble and a file card below it.")
        source: "qrc:/demos/message/Attachment.qml"
        previewMinHeight: 340
    }
    ExampleCard {
        title: qsTr("Alignment")
        description: qsTr("Start and end alignment for receiver and sender rows via the align property.")
        source: "qrc:/demos/message/Alignment.qml"
    }
}
