import QtQuick

/*!
    \qmltype FocusRing
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief Draws the shadcn focus-visible ring around a target background.

    FocusRing is an internal utility that renders base-mira's
    \c {focus-visible:ring} treatment (Tailwind \c {ring-<width> ring-ring/<opacity>}
    with no ring-offset). All appearance is token-driven from \l Theme: thickness is
    \c Theme.ringWidth, the color is \c Theme.ring at \c Theme.ringOpacity, so the ring
    stays consistent across every control and follows theme changes automatically.

    Place it \e inside the target's background \l Rectangle. It anchors-fills the parent
    and grows outward by \c Theme.ringWidth on every side (\c {anchors.margins:
    -Theme.ringWidth}), then paints its border in that expanded band. Because a Qt Quick
    border is inset, the stroke occupies exactly the \c Theme.ringWidth band just outside
    the parent's edge, hugging it with no gap (matching CSS \c ring, which has no offset).
    \l z is \c -1 so the ring sits behind the parent's own content.

    Corner radii track the target so the ring stays equidistant. Pass the target
    background's radius as \l targetRadius; each ring corner becomes
    \c {targetRadius + Theme.ringWidth}. A target corner of \c 0 (a square corner) keeps
    the ring corner square. For controls whose corners differ (e.g. grouped buttons with
    flattened inner corners), set the per-corner \l targetTopLeft, \l targetTopRight,
    \l targetBottomLeft and \l targetBottomRight to each corner's target radius; \c -1
    (the default) means "use \l targetRadius".

    Visibility is gated entirely by \l active; callers bind it to the appropriate focus
    condition (typically \c visualFocus for button-like controls or \c activeFocus for
    text inputs).

    \qml
    Rectangle {
        id: bg
        radius: Theme.radiusMd
        FocusRing { active: control.visualFocus; targetRadius: bg.radius }
    }
    \endqml
*/
Rectangle {
    id: root

    /*! \qmlproperty bool FocusRing::active \brief Shows the ring while \c true; hides it otherwise. Defaults to \c false. */
    property bool active: false
    /*! \qmlproperty real FocusRing::targetRadius \brief Radius of the target background; each ring corner becomes this plus \c Theme.ringWidth. Defaults to \c Theme.radiusMd. */
    property real targetRadius: Theme.radiusMd
    /*! \qmlproperty real FocusRing::targetTopLeft \brief Per-corner target radius for the top-left corner; \c -1 uses \l targetRadius. Defaults to \c -1. */
    property real targetTopLeft: -1
    /*! \qmlproperty real FocusRing::targetTopRight \brief Per-corner target radius for the top-right corner; \c -1 uses \l targetRadius. Defaults to \c -1. */
    property real targetTopRight: -1
    /*! \qmlproperty real FocusRing::targetBottomLeft \brief Per-corner target radius for the bottom-left corner; \c -1 uses \l targetRadius. Defaults to \c -1. */
    property real targetBottomLeft: -1
    /*! \qmlproperty real FocusRing::targetBottomRight \brief Per-corner target radius for the bottom-right corner; \c -1 uses \l targetRadius. Defaults to \c -1. */
    property real targetBottomRight: -1

    // Resolve one corner's ring radius. A negative corner falls back to
    // targetRadius; a target radius of 0 keeps the ring corner square (0),
    // otherwise the ring corner is the target radius plus the ring width so
    // the stroke stays equidistant from the target edge.
    function _ringR(corner) {
        var t = (corner < 0) ? targetRadius : corner
        return t <= 0 ? 0 : t + Theme.ringWidth
    }

    anchors.fill: parent
    anchors.margins: -Theme.ringWidth
    radius: _ringR(-1)
    topLeftRadius: _ringR(targetTopLeft)
    topRightRadius: _ringR(targetTopRight)
    bottomLeftRadius: _ringR(targetBottomLeft)
    bottomRightRadius: _ringR(targetBottomRight)
    color: "transparent"
    border.width: Theme.ringWidth
    border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
    visible: active
    z: -1
}
