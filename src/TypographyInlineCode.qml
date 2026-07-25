import QtQuick

/*!
    \qmltype TypographyInlineCode
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief An inline code chip, styled after shadcn's base-mira inline
    \c code.

    TypographyInlineCode renders shadcn's inline \c code prose style: a
    \l {Theme::muted}{muted} pill (\c bg-muted) with \c rounded corners (4px)
    and \c px-[0.3rem] / \c py-[0.2rem] padding (4.8px x 3.2px), wrapping
    \c font-mono \c text-sm (14px) \c font-semibold text in the
    \l {Theme::foreground}{foreground} color.

    \qml
    TypographyInlineCode { text: "@radix-ui/react-alert-dialog" }
    \endqml
*/
Rectangle {
    id: root

    /*!
        \qmlproperty string TypographyInlineCode::text
        The code text.
    */
    // Code text, forwarded to the inner label.
    property alias text: codeText.text

    implicitWidth: codeText.implicitWidth + 2 * 4.8    // px-[0.3rem]
    implicitHeight: codeText.implicitHeight + 2 * 3.2  // py-[0.2rem]
    radius: 4                             // rounded (Tailwind default)
    color: Theme.muted                    // bg-muted

    Text {
        id: codeText
        anchors.centerIn: parent
        color: Theme.foreground
        font.family: Theme.fontMono       // font-mono
        font.pixelSize: Theme.textSm      // text-sm (14)
        font.weight: Font.DemiBold        // font-semibold (600)
        textFormat: Text.PlainText
    }
}
