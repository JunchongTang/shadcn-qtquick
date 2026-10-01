import QtQuick
import QtTest
import Shadcn

// The modal backdrop is a blur under a scrim, and the blur is stated the way
// CSS states it: as a gaussian's standard deviation in logical pixels. Nothing
// in Qt guarantees that a given effect's "blur" parameter means that, so it is
// measured back out here rather than assumed -- Qt's own MultiEffect, which
// this replaced, needed a piecewise empirical table and still drifted between
// its pyramid levels.
Item {
    id: root
    width: 400
    height: 120

    property real testRadius: Theme.overlayBlur

    // A hard black-to-white step, blurred exactly the way OverlayBackdrop does.
    Item {
        id: step
        anchors.fill: parent
        visible: false
        Rectangle { anchors.fill: parent; color: "#000000" }
        Rectangle { x: parent.width / 2; width: parent.width / 2; height: parent.height; color: "#ffffff" }
    }

    // BlurChain samples its source as a texture, so it has to be given a
    // texture provider; handing it the Item directly yields an empty result.
    ShaderEffectSource {
        id: tap
        anchors.fill: parent
        sourceItem: step
        live: true
        hideSource: false
        visible: false
    }

    // Grabbed as a control: it is plain Rectangles, so a backend that renders
    // it but not the BlurChain below is one without shader support, which is a
    // skip. A backend that renders neither cannot be grabbed at all.
    Item {
        id: plainStep
        anchors.fill: parent
        Rectangle { anchors.fill: parent; color: "#000000" }
        Rectangle { x: parent.width / 2; width: parent.width / 2; height: parent.height; color: "#ffffff" }
    }

    BlurChain {
        id: blurred
        anchors.fill: parent
        source: tap
        radius: root.testRadius
    }

    TestCase {
        name: "OverlayBackdrop"
        when: windowShown

        function test_tokens_follow_luma_not_mira() {
            // A deliberate departure from base-mira, which would be black/80 at
            // 4px. See Theme::overlayScrimOpacity for why.
            compare(Theme.overlayScrimOpacity, 0.30)
            compare(Theme.overlayScrim.a, 0.30)
            compare(Theme.overlayScrim.r, 0)
            compare(Theme.overlayBlur, 8)
        }

        // Standard deviation recovered from the blurred step: differentiating
        // the edge response gives the line-spread function, whose second moment
        // is the sigma that produced it.
        function measuredSigma(item) {
            const shot = grabImage(item)
            const y = Math.floor(shot.height / 2)
            const ratio = shot.width / root.width      // device pixels per logical pixel

            let profile = []
            for (let x = 0; x < shot.width; ++x)
                profile.push(shot.red(x, y) / 255)

            let lsf = [], total = 0
            for (let i = 0; i < profile.length - 1; ++i) {
                const d = profile[i + 1] - profile[i]
                lsf.push(d)
                total += d
            }
            if (total <= 0)
                return -1

            let mean = 0
            for (let i = 0; i < lsf.length; ++i)
                mean += i * lsf[i]
            mean /= total

            let variance = 0
            for (let i = 0; i < lsf.length; ++i)
                variance += lsf[i] * Math.pow(i - mean, 2)
            variance /= total

            return Math.sqrt(variance) / ratio
        }

        function test_radius_is_the_sigma_data() {
            return [
                { tag: "4px",  radius: 4 },
                { tag: "8px",  radius: 8 },   // the shipped value
                { tag: "12px", radius: 12 },
            ]
        }

        // Not just the shipped radius: the point of this blur over MultiEffect
        // is that the relation stays linear, so a reader who changes
        // Theme.overlayBlur gets what the number says.
        function test_radius_is_the_sigma(data) {
            root.testRadius = data.radius
            wait(80)

            // -1 means the grab held no edge at all. On its own that is
            // ambiguous, so the shader-free control settles it: if even that
            // yields nothing the backend cannot be grabbed here and the case is
            // a skip, whereas a readable control with an unreadable blur is the
            // blur having genuinely stopped working.
            const sigma = measuredSigma(blurred)
            if (sigma < 0) {
                if (measuredSigma(plainStep) < 0)
                    skip("this backend renders nothing that can be grabbed")
                fail("the control grabbed but the blurred source did not: "
                     + "BlurChain produced no image")
            }
            if (sigma < 0.5)
                skip("this backend did not blur the source at all")

            fuzzyCompare(sigma, data.radius, data.radius * 0.12,
                         "BlurChain's radius no longer measures back as the sigma")
        }
    }
}
