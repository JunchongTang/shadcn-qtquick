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
    // Official sections still skipped (depend on calendar capabilities not yet implemented):
    // Multiple (multi-select), Presets (range preset sidebar), Date and Time Picker,
    // Booked dates (disabled days), Week Numbers, Persian/Hijri, RTL.
    // Simplification: multi-month view navigation moves 1 month at a time (pagedNavigation full-page flip not implemented);
    //       cross-month range continuity relies on each column's leading/trailing outside-month fill cells (showOutsideDays), matching the official behavior.
}
