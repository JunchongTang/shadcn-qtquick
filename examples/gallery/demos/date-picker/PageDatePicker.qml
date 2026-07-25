import QtQuick

PageScaffold {
    description: qsTr("A date picker component built from a Popover and a Calendar.")

    ExampleCard {
        title: qsTr("Date Picker")
        description: qsTr("An outline trigger (placeholder + trailing chevron) that opens a single-date calendar; picking a day fills the formatted date and closes the popover.")
        source: "qrc:/demos/date-picker/Demo.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: qsTr("With Field Label")
        description: qsTr("A date picker wrapped in a labelled field (equivalent to the official Field + FieldLabel basic example).")
        source: "qrc:/demos/date-picker/Field.qml"
        previewMinHeight: 380
    }
    ExampleCard {
        title: qsTr("Range Picker")
        description: qsTr("A DateRangePicker: an outline trigger opens a two-month range calendar; picking start then end fills the \"start - end\" text and closes the popover.")
        source: "qrc:/demos/date-picker/Range.qml"
        previewMinHeight: 380
    }
    ExampleCard {
        title: qsTr("With Presets")
        description: qsTr("A composition that injects quick presets (Today, Tomorrow, In 3 days, In a week) above the calendar inside the popover.")
        source: "qrc:/demos/date-picker/Presets.qml"
        previewMinHeight: 460
    }
    // 已跳过的官方小节(依赖尚未实现的组件/库):
    //   · Date of Birth  —— 需 Calendar captionLayout="dropdown" 组合入 picker,当前仅在 Calendar 页演示,跳过。
    //   · Input          —— 需 InputGroup 组件 + 可输入解析日期,均未实现,跳过。
    //   · Time Picker    —— 需 dropdown caption + 独立时间输入,跳过。
    //   · Natural Language—— 需 chrono-node 自然语言解析,无对应实现,跳过。
    //   · RTL            —— 按约定跳过 RTL 小节。
}
