import QtQuick
import QtTest
import Shadcn

// RoundedImage unit tests: verify that the public source/radius/fillMode
// properties are wired through to the internal Image and mask Rectangle, that
// the offscreen layer + MultiEffect pipeline is assembled correctly, and that
// radius == height/2 drives a circle. Appearance is asserted by reading the
// driving properties and geometry of the internal nodes (not rasterized
// pixels), which is deterministic under the offscreen platform. No source is
// loaded, so status stays Image.Null and nothing depends on real image I/O.
Item {
    id: root
    width: 320
    height: 240

    // Default construction (radius 0, default fillMode).
    RoundedImage {
        id: riDefault
        width: 64
        height: 64
    }

    // Square host with a circular radius (== height/2).
    RoundedImage {
        id: riCircle
        width: 40
        height: 40
        radius: 20
        fillMode: Image.PreserveAspectCrop
    }

    // Rounded (non-circular) with an explicit non-default fillMode.
    RoundedImage {
        id: riRounded
        width: 120
        height: 80
        radius: 12
        fillMode: Image.Stretch
    }

    TestCase {
        name: "RoundedImage"
        when: windowShown

        // Depth-first search for a descendant by objectName.
        function _find(item, name) {
            var kids = item.children
            for (var i = 0; i < kids.length; ++i) {
                if (kids[i].objectName === name)
                    return kids[i]
                var found = _find(kids[i], name)
                if (found)
                    return found
            }
            return null
        }

        function _image(ri) { return _find(ri, "image") }
        function _maskRect(ri) { return _find(ri, "maskRect") }
        function _effect(ri) { return _find(ri, "effect") }

        // The internal pipeline (source Image, mask Rectangle, MultiEffect) exists.
        function test_pipeline_assembled() {
            verify(_image(riDefault) !== null, "internal Image present")
            verify(_maskRect(riDefault) !== null, "internal mask Rectangle present")
            verify(_effect(riDefault) !== null, "internal MultiEffect present")
        }

        // The source Image is offscreen (hidden) and layered so its fillMode crop
        // is baked into a texture; the mask is layered and hidden too.
        function test_offscreen_layers() {
            var im = _image(riDefault)
            compare(im.visible, false)
            compare(im.layer.enabled, true)
            // Mask Rectangle lives inside a hidden, layered Item.
            var mr = _maskRect(riDefault)
            compare(mr.parent.visible, false)
            compare(mr.parent.layer.enabled, true)
        }

        // radius is forwarded to the mask Rectangle that shapes the clip.
        function test_radius_passthrough() {
            compare(_maskRect(riDefault).radius, 0)
            compare(_maskRect(riRounded).radius, 12)
        }

        // radius reacts at runtime and keeps driving the mask.
        function test_radius_reactive() {
            compare(_maskRect(riDefault).radius, 0)
            riDefault.radius = 16
            compare(_maskRect(riDefault).radius, 16)
            riDefault.radius = 0 // restore for isolation
        }

        // radius == height/2 on a square item drives a circle (mask radius reaches
        // the clamp point min(w,h)/2).
        function test_circle_radius() {
            var mr = _maskRect(riCircle)
            compare(mr.radius, 20)
            compare(mr.radius, riCircle.height / 2)
        }

        // source is forwarded to the internal Image; empty by default.
        function test_source_passthrough() {
            compare(String(riDefault.source), "")
            compare(String(_image(riDefault).source), "")
            riDefault.source = "image://dummy/x"
            compare(String(_image(riDefault).source), "image://dummy/x")
            riDefault.source = "" // restore for isolation
        }

        // fillMode defaults to PreserveAspectCrop and forwards to the Image; a
        // non-default value also propagates.
        function test_fillmode_passthrough() {
            compare(riDefault.fillMode, Image.PreserveAspectCrop)
            compare(_image(riDefault).fillMode, Image.PreserveAspectCrop)
            compare(_image(riRounded).fillMode, Image.Stretch)
        }

        function test_fillmode_reactive() {
            riDefault.fillMode = Image.PreserveAspectFit
            compare(_image(riDefault).fillMode, Image.PreserveAspectFit)
            riDefault.fillMode = Image.PreserveAspectCrop // restore
        }

        // status is aliased from the internal Image; with no source it is Null.
        function test_status_alias() {
            compare(riDefault.status, Image.Null)
            compare(riDefault.status, _image(riDefault).status)
        }

        // Internal Image and MultiEffect fill the component's bounds so the mask
        // aligns 1:1 with the cropped source (no stretch mismatch).
        function test_geometry_fills_bounds() {
            var im = _image(riCircle)
            compare(im.width, riCircle.width)
            compare(im.height, riCircle.height)
            var eff = _effect(riCircle)
            compare(eff.width, riCircle.width)
            compare(eff.height, riCircle.height)
            var mr = _maskRect(riCircle)
            compare(mr.width, riCircle.width)
            compare(mr.height, riCircle.height)
        }

        // The masked output is gated on Image.Ready, so with no source the effect
        // stays hidden (nothing flashes while unloaded).
        function test_effect_hidden_until_ready() {
            compare(_effect(riDefault).visible, false)
            compare(_effect(riDefault).maskEnabled, true)
        }
    }
}
