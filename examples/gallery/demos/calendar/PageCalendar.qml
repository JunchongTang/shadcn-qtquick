import QtQuick

PageScaffold {
    description: qsTr("A date field component that allows users to enter and edit date.")

    ExampleCard {
        title: qsTr("Calendar")
        description: qsTr("A single-date month calendar. Click a day to select it; use the chevrons to change month.")
        source: "qrc:/demos/calendar/Demo.qml"
        previewMinHeight: 340
    }
    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A basic calendar with no preselected date, wrapped with rounded-lg border.")
        source: "qrc:/demos/calendar/Basic.qml"
        previewMinHeight: 340
    }
    ExampleCard {
        title: qsTr("Custom Cell Size")
        description: qsTr("Customize the size of calendar cells via the cellSize property.")
        source: "qrc:/demos/calendar/CustomSize.qml"
        previewMinHeight: 380
    }
    ExampleCard {
        title: qsTr("Range Calendar")
        description: qsTr("Set mode: Calendar.Range to select a start and end date. Endpoints are primary pills; days in between form a connected muted band.")
        source: "qrc:/demos/calendar/Range.qml"
        previewMinHeight: 340
    }
    ExampleCard {
        title: qsTr("Range Calendar (Two Months)")
        description: qsTr("Set numberOfMonths: 2 to render two consecutive months side by side under one shared navigation. Range highlighting stays continuous across the month boundary.")
        source: "qrc:/demos/calendar/RangeTwoMonths.qml"
        previewMinHeight: 340
    }
    ExampleCard {
        title: qsTr("Month and Year Selector")
        description: qsTr("Set captionLayout: Calendar.Dropdown to switch month and year with dropdowns instead of a text label.")
        source: "qrc:/demos/calendar/DropdownCaption.qml"
        previewMinHeight: 340
    }
    // 仍跳过的官方小节(依赖当前月历尚未实现的能力):
    // Multiple(多选)、Presets(区间预设侧栏)、Date and Time Picker、
    // Booked dates(禁用日)、Week Numbers(周号)、Persian/Hijri、RTL。
    // 简化:多月视图导航每次移动 1 个月(未实现 pagedNavigation 整页翻);
    //       跨月区间连续性依赖各列首尾外月补格(showOutsideDays)衔接,与官方一致。
}
