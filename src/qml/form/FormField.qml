import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FormField
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Vertical form field: label, control slot, description and error.
    \image form.png


    Ports shadcn/ui \c Field / \c FieldLabel / \c FieldDescription /
    \c FieldError from the base-mira registry (\c field.tsx). It reproduces the
    structure and visuals of a vertical field (\c .cn-field \c gap-2, muted
    description, destructive error, \c data-invalid -> destructive label) but
    not the validation engine: upstream relies on react-hook-form + zod, which
    has no QML equivalent. The caller drives state instead: assign \l error
    (a non-empty string marks the invalid state) and bind a control's \c invalid
    property to \l invalid.

    \qml
    FormField {
        id: field
        label: "Email"
        required: true
        description: "We'll never share it."
        error: submitted && !valid ? "Enter a valid email." : ""
        Input { Layout.fillWidth: true; invalid: field.invalid }
    }
    \endqml
*/
ColumnLayout {
    id: field

    /*! The label text shown above the control. Hidden when empty. */
    property string label: ""
    /*! When true, appends a destructive-coloured asterisk after the label. */
    property bool required: false
    /*! Optional muted helper text shown below the control. */
    property string description: ""
    /*! Optional destructive error text; shown while non-empty and marks the field invalid. */
    property string error: ""
    /*! True while \l error is non-empty; bind a control's \c invalid property to this. */
    readonly property bool invalid: field.error !== ""
    /*! Default slot: the placed control(s), e.g. Input / Textarea / Select. */
    default property alias controlData: slot.data

    spacing: Theme.space2                               // .cn-field gap-2

    // ---- Label (+ required asterisk); turns destructive when invalid (data-invalid) ----
    RowLayout {
        Layout.fillWidth: true
        spacing: 2
        visible: field.label !== ""
        Label {
            text: field.label
            color: field.invalid ? Theme.destructive : Theme.foreground
        }
        Label {
            text: "*"
            color: Theme.destructive
            visible: field.required
        }
    }

    // ---- Control slot (caller places the control here and sets Layout.fillWidth) ----
    ColumnLayout {
        id: slot
        Layout.fillWidth: true
        spacing: Theme.space2
    }

    // ---- Description (muted) ----
    FormDescription {
        Layout.fillWidth: true
        text: field.description
    }

    // ---- Error (destructive; shown while error is non-empty) ----
    FormMessage {
        Layout.fillWidth: true
        text: field.error
    }
}
