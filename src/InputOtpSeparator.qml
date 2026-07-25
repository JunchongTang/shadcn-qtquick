import QtQuick
import LucideIcons

/*!
    \qmltype InputOtpSeparator
    \inqmlmodule Shadcn
    \inherits Item
    \brief Divider drawn between OTP slot groups, matching shadcn/ui base-mira.

    InputOtpSeparator maps the base-mira \c {.cn-input-otp-separator} utility: a
    single centered \l LucideIcon (default \c minus, \c size-4 / 16px) rendered in
    the current text color (\c Theme.foreground). It is inserted automatically by
    \l InputOtp between adjacent groups; it carries no state and is purely visual.

    \qml
    InputOtpSeparator {}
    InputOtpSeparator { iconName: "dot" }
    \endqml
*/
Item {
    id: root

    /*! \qmlproperty string InputOtpSeparator::iconName
        Name of the \l LucideIcon shown as the separator glyph.
        Defaults to \c "minus" (the base-mira \c MinusIcon). */
    property string iconName: "minus"

    implicitWidth: 16
    implicitHeight: 28

    LucideIcon {
        anchors.centerIn: parent
        name: root.iconName
        size: 16                        // svg size-4
        color: Theme.foreground         // currentColor (no muted class in base-mira)
    }
}
