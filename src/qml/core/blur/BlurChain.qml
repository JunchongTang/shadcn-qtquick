import QtQuick

/*!
    \internal
    Vendored from LayerFx (github.com/JunchongTang/layerfx-qtquick, MIT) at
    commit 31b5444, unchanged apart from the shader URLs, which point at this
    module's own resource prefix. Kept because Qt's own MultiEffect states its
    blur as a fraction of an opaque blurMax rather than as a radius: recovering
    a sigma from it needs an empirical table, and the table is piecewise --
    blurMax 32 gives sigma 7.85 and 34 gives 10.44, with nothing in between.
    This states sigma directly and measures back linearly (radius 2..16 all
    within 4%), which is what CSS blur() means too.

    A pyramid gaussian blur: progressive 2x downsamples, a small
    separable gaussian at the top, then progressive tent upsamples.

    Every pass renders at full item size; only the tap textures shrink. That
    keeps one coordinate system across the whole pyramid, so each shader's
    step is simply one texel of whatever level it is reading.

    The pyramid depth is chosen so the gaussian's sigma always lands in roughly
    1.5..3 texels. Sigma stays small no matter how large the requested radius,
    which is what keeps the kernel dense and free of the ringing a wide-stride
    kernel produces.
*/
Item {
    id: root

    property Item source: null
    property real radius: 8

    readonly property int passCount: d.passCount

    readonly property int levels: Math.max(0, Math.min(6,
        Math.ceil(Math.log2(Math.max(1, radius / 3)))))
    readonly property real sigma: radius / Math.pow(2, levels)

    /*!
        ShaderEffectSource.textureSize is in device pixels. Level 0 has to match
        the screen exactly or the whole pyramid renders at a fraction of the
        real resolution and gets magnified back -- which reads as an aliased
        source once the radius is small enough to stop hiding it.
    */
    readonly property real pixelRatio: Screen.devicePixelRatio

    onSourceChanged: d.rebuild()
    onLevelsChanged: d.rebuild()

    Component.onCompleted: {
        d.ready = true;
        d.rebuild();
    }

    Component.onDestruction: d.clear()

    Component {
        id: tapComponent

        ShaderEffectSource {
            anchors.fill: parent
            hideSource: true
            live: true
            smooth: true
            visible: false
        }
    }

    Component {
        id: downsampleComponent

        ShaderEffect {
            anchors.fill: parent
            blending: false

            property Item source: null
            property vector2d texelSize: Qt.vector2d(0, 0)

            fragmentShader: "qrc:/qt/qml/Shadcn/shaders/downsample.frag.qsb"
        }
    }

    Component {
        id: gaussComponent

        ShaderEffect {
            anchors.fill: parent
            blending: false

            property Item source: null
            property real sigma: 1
            property vector2d direction: Qt.vector2d(0, 0)

            fragmentShader: "qrc:/qt/qml/Shadcn/shaders/gauss.frag.qsb"
        }
    }

    Component {
        id: upsampleComponent

        ShaderEffect {
            anchors.fill: parent
            blending: false

            property Item source: null
            property vector2d texelSize: Qt.vector2d(0, 0)

            fragmentShader: "qrc:/qt/qml/Shadcn/shaders/upsample.frag.qsb"
        }
    }

    QtObject {
        id: d

        property bool ready: false
        property int passCount: 0
        property var owned: []

        /*!
            One texel of the given pyramid level, in normalised coordinates.

            This has to agree with tapAt's device-pixel texture size. Deriving it
            from the logical width instead makes the down- and upsample filters
            step over two texels at a time on a retina display, skipping every
            other one -- which aliases at every level and compounds into visible
            blockiness by the bottom of a deep pyramid.
        */
        function texelOf(level) {
            const f = Math.pow(2, level);
            return Qt.binding(() => Qt.vector2d(
                f / Math.max(1, root.width * root.pixelRatio),
                f / Math.max(1, root.height * root.pixelRatio)));
        }

        function tapAt(item, level) {
            const f = Math.pow(2, level);
            const t = tapComponent.createObject(root, { sourceItem: item });
            t.textureSize = Qt.binding(() => Qt.size(
                Math.max(1, Math.round(root.width * root.pixelRatio / f)),
                Math.max(1, Math.round(root.height * root.pixelRatio / f))));
            owned.push(t);
            return t;
        }

        function clear() {
            for (let i = 0; i < owned.length; ++i)
                owned[i].destroy();
            owned = [];
        }

        function rebuild() {
            if (!ready)
                return;

            clear();

            if (!root.source) {
                passCount = 0;
                return;
            }

            const levels = root.levels;
            let input = root.source;
            let count = 0;

            for (let k = 1; k <= levels; ++k) {
                const down = downsampleComponent.createObject(root, { source: input });
                down.texelSize = texelOf(k - 1);
                owned.push(down);
                ++count;
                input = tapAt(down, k);
            }

            const horizontal = gaussComponent.createObject(root, { source: input });
            horizontal.sigma = Qt.binding(() => root.sigma);
            horizontal.direction = Qt.binding(() => Qt.vector2d(
                Math.pow(2, levels) / Math.max(1, root.width), 0));
            owned.push(horizontal);
            ++count;
            input = tapAt(horizontal, levels);

            const vertical = gaussComponent.createObject(root, { source: input });
            vertical.sigma = Qt.binding(() => root.sigma);
            vertical.direction = Qt.binding(() => Qt.vector2d(
                0, Math.pow(2, levels) / Math.max(1, root.height)));
            owned.push(vertical);
            ++count;

            if (levels === 0) {
                vertical.blending = true;
                passCount = count;
                return;
            }

            input = tapAt(vertical, levels);

            for (let k = levels; k >= 1; --k) {
                const up = upsampleComponent.createObject(root, { source: input });
                up.texelSize = texelOf(k);
                owned.push(up);
                ++count;

                if (k === 1) {
                    up.blending = true;
                    break;
                }

                input = tapAt(up, k - 1);
            }

            passCount = count;
        }
    }
}
