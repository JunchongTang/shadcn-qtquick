import QtQuick

/*!
    \qmltype OverlayBackdrop
    \inqmlmodule Shadcn
    \inherits Item
    \brief Backdrop for a modal popup: the application behind it, blurred, under a scrim.

    Mirrors what the shadcn overlays do in CSS -- \c {bg-black/80} over
    \c {backdrop-filter: blur(...)} -- which a plain dim cannot reproduce,
    because a dim only darkens while a backdrop filter also destroys the detail
    underneath. Assign it to a popup's modal overlay:

    \qml
    QQC.Overlay.modal: OverlayBackdrop { }
    \endqml

    Both halves come from \l Theme by default: \l Theme::overlayScrim for the
    dim and \l Theme::overlayBlur for the blur. Setting \l Theme::overlayBlur to
    \c 0 leaves the scrim alone and skips the capture entirely, so the cost is
    opt-out rather than unconditional.

    \note Only one subtree is blurred: the largest child of the window's content
    item that is not the overlay this backdrop lives in. That is the whole
    application in the usual single-root layout, but a window that puts several
    large siblings directly under its content item only gets the biggest blurred --
    and only that one is hidden behind the blur, so a small floating sibling (a drag
    ghost, a toast layer) stays sharp over it. Qt Quick cannot render a subtree while
    excluding a node from it, so the overlay has to be excluded by picking a sibling
    rather than by masking.
*/
Item {
    id: root

    /*!
        Standard deviation of the gaussian, in logical pixels, matching the
        argument CSS \c {blur()} takes. Defaults to \l Theme::overlayBlur.
    */
    property real blurRadius: Theme.overlayBlur

    /*! Dim drawn over the blurred content. Defaults to \l Theme::overlayScrim. */
    property color scrimColor: Theme.overlayScrim

    /*!
        Re-capture the content behind every frame. Needed whenever that content
        animates; turning it off freezes the backdrop at whatever it last was,
        which costs nothing per frame.
    */
    property bool live: true

    /*!
        \readonly
        The subtree being blurred, or \c null when there is nothing to blur.
    */
    readonly property Item blurredItem: {
        const contentItem = root.Window.contentItem
        if (!contentItem)
            return null

        // Identify our own branch by walking up to the window's content item,
        // rather than assuming the overlay is exactly root.parent: a popup's
        // modal item is reparented by QQuickOverlay and the depth is not ours
        // to rely on.
        let ours = root
        while (ours && ours.parent !== contentItem)
            ours = ours.parent

        // Largest by area, not first or last. Position says nothing about which
        // child is the application: one may keep small floating items as direct
        // window children -- a drag ghost, a HUD, a toast layer -- and nothing
        // orders those after the main layout. Taking the first then snapshots,
        // say, a 26px chip and stretches it over the whole window, one enormous
        // blurred glyph where the application should be; taking the last picks
        // up an empty toast layer and blurs nothing at all. Both have happened.
        //
        // No visibility filter, tempting as it looks -- a ShaderEffectSource
        // renders its sourceItem even while that item is hidden, so a hidden
        // ghost is still a candidate. Item::visible is the *effective* value,
        // false whenever an ancestor or the window is not shown yet, which is
        // exactly when this is first evaluated: the main content would lose to a
        // 26px sibling. Area alone already rules small hidden items out.
        let best = null
        let bestArea = -1
        for (let i = 0; i < contentItem.children.length; ++i) {
            const child = contentItem.children[i]
            if (child === ours)
                continue
            const area = child.width * child.height
            if (area > bestArea) {
                best = child
                bestArea = area
            }
        }
        // Null rather than the content item itself when there is no candidate:
        // the content item holds the overlay this backdrop lives in, so using it
        // would feed the capture back into itself. Null just turns the blur off.
        return bestArea > 0 ? best : null
    }

    readonly property bool blurActive: root.blurRadius > 0 && root.blurredItem !== null

    // Qt shows a modal overlay by stepping opacity straight to 1. The shadcn
    // overlays specify duration-100 with fade-in-0/fade-out-0, so the step
    // becomes a fade of Theme.durFast, which is that same 100ms.
    Behavior on opacity {
        NumberAnimation { duration: Theme.durFast }
    }

    ShaderEffectSource {
        id: capture

        anchors.fill: parent
        sourceItem: root.blurActive ? root.blurredItem : null
        live: root.live
        recursive: false
        visible: false              // consumed by the BlurChain below

        // **Replace** the captured subtree rather than draw over it. A
        // ShaderEffectSource re-renders its source into a transparent texture, so the
        // copy is only as opaque as what those items actually paint -- and an
        // application root normally paints nothing of its own, its background coming
        // from the window. Left in the scene, the original then shows through its own
        // blurred copy, sharp, with a blurred ghost on top: text on a card blurs while
        // text on the page background does not.
        //
        // The previous fix laid an opaque base of Window.color underneath. That works
        // only while the window has a colour: a translucent window (macOS vibrancy or
        // liquid glass, where the material is composited by the window server *under*
        // the Qt surface and the clear colour is transparent by necessity) paints no
        // base at all, and the blur silently does nothing. Hiding the source has no
        // such dependency, and it is what the property is for -- input still reaches
        // the hidden item, which a modal blocks anyway.
        //
        // Only while fully shown. Qt steps a modal overlay's opacity to 1 and this
        // backdrop fades it (see below); during that fade the original has to stay,
        // because the fade *is* the cross-fade from sharp to blurred -- CSS does the
        // same, blending the filtered backdrop with the unfiltered one by the
        // element's opacity. Hiding it up front would blink the application out and
        // fade it back in instead.
        hideSource: root.opacity >= 1
    }

    // BlurChain rather than Qt's MultiEffect. MultiEffect states its blur as a
    // 0..1 fraction of an opaque blurMax, which is not a sigma and converts to
    // one only through a measured table that turns out to be piecewise -- at
    // DPR 2 on Qt 6.11, blurMax 32 gives sigma 7.85 and 34 gives 10.44, with no
    // value in between. BlurChain's radius is the sigma, in logical pixels,
    // exactly as CSS blur() means it: measured back at radius 2, 4, 6, 8, 12
    // and 16, every one lands within 4% of its own radius.
    BlurChain {
        anchors.fill: parent
        visible: root.blurActive
        source: root.blurActive ? capture : null
        radius: root.blurRadius
    }

    Rectangle {
        anchors.fill: parent
        color: root.scrimColor
    }
}
