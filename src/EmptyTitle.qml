import QtQuick
import QtQuick.Layouts

/*!
    \qmltype EmptyTitle
    \inqmlmodule Shadcn
    \inherits Text
    \brief Title text for an Empty, matching base-mira EmptyTitle.

    Mirrors \c .cn-empty-title (text-sm font-medium tracking-tight + cn-font-heading;
    centered, wrapping). Uses the heading font at text-sm (14px), medium weight, with
    tight letter spacing.
*/
Text {
    Layout.fillWidth: true
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: Theme.textSm         // text-sm = 14
    font.weight: Font.Medium
    font.letterSpacing: -0.35            // tracking-tight ~= -0.025em x 14
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap
}
