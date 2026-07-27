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
    // Official sections skipped (depend on components/libraries not yet implemented):
    //   · Date of Birth  —— needs Calendar captionLayout="dropdown" composed into the picker; currently only demoed on the Calendar page, skipped.
    //   · Input          —— needs the InputGroup component + editable date parsing, neither implemented, skipped.
    //   · Time Picker    —— needs dropdown caption + a separate time input, skipped.
    //   · Natural Language—— needs chrono-node natural-language parsing, no equivalent, skipped.
    //   · RTL            —— RTL sections skipped by convention.
}
