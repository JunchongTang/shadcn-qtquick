import QtQuick

/*!
    \qmltype InputGroupButton
    \inqmlmodule Shadcn
    \inherits Button
    \brief A small button placed inside an InputGroupAddon
    (\c .cn-input-group-button), styled after shadcn/ui base-mira.

    InputGroupButton defaults to the \c Ghost variant at the extra-small size and
    reuses the library \l Button for its variant, icon slots, focus ring and hover
    behaviour. Its \l kind maps to the concrete \c Button size (base-mira metrics),
    and it flags itself so a surrounding InputGroupAddon applies the edge-pull
    negative margin.

    \sa InputGroupAddon, Button
*/
Button {
    id: btn

    /*!
        \qmlproperty enumeration InputGroupButton::kind
        Size preset. Defaults to \c InputGroupButton.KindXs.
        \value InputGroupButton.KindXs Text, maps to Button.Xs (h-5, 20px).
        \value InputGroupButton.KindSm Text, maps to Button.Sm (h-6, 24px).
        \value InputGroupButton.KindIconXs Square icon, maps to Button.IconSm (size-6, 24px).
        \value InputGroupButton.KindIconSm Square icon, maps to Button.Icon (size-7, 28px).
    */
    enum Kind { KindXs, KindSm, KindIconXs, KindIconSm }

    /*!
        \qmlproperty enumeration InputGroupButton::kind
        See \l Kind.
    */
    property int kind: InputGroupButton.KindXs
    /*! \qmlproperty bool InputGroupButton::_igButton
        Marker letting the addon apply the button edge-pull margin. \internal */
    readonly property bool _igButton: true

    variant: Button.Ghost
    size: {
        switch (kind) {
        case InputGroupButton.KindSm:     return Button.Sm
        case InputGroupButton.KindIconXs: return Button.IconSm
        case InputGroupButton.KindIconSm: return Button.Icon
        default:                          return Button.Xs
        }
    }
}
