import QtQuick

/*!
    \qmltype ToastArea
    \inqmlmodule Shadcn
    \inherits Item
    \brief A self-managed container that stacks and auto-dismisses Sonner-style toasts.

    ToastArea is the shadcn Sonner toaster: a component-local manager (no global
    singleton) that stacks \l Toast cards in one corner of its bounds, animates
    them in (slide + fade) and out (fade + slide back), and removes each one after
    its dwell time elapses. Typically it is placed to cover a region
    (\c anchors.fill) at a high \c z, and toasts are pushed through the API.

    \qml
    ToastArea {
        id: toaster
        anchors.fill: parent
        position: ToastArea.BottomEnd
        z: 1000
    }
    // elsewhere:
    toaster.success("Copied to clipboard", { description: path, duration: 2000 })
    \endqml

    \sa Toast
*/
Item {
    id: area

    /*!
        \qmlproperty enumeration ToastArea::position
        The corner (and stacking edge) that toasts anchor to.

        \note Members deliberately avoid the names \c TopLeft / \c TopRight /
        \c BottomLeft / \c BottomRight / \c Center. Those collide with the
        inherited \c Item.TransformOrigin enumeration (QML flattens enum names
        into the type scope and \c TransformOrigin wins), which would silently
        remap the values. \c Start means the left edge and \c End the right edge.

        \value ToastArea.TopStart     Top-left corner; slides in from the left.
        \value ToastArea.TopCenter    Top edge, centered; slides down.
        \value ToastArea.TopEnd       Top-right corner; slides in from the right.
        \value ToastArea.BottomStart  Bottom-left corner; slides in from the left.
        \value ToastArea.BottomCenter Bottom edge, centered; slides up.
        \value ToastArea.BottomEnd    Bottom-right corner; slides in from the right. (default)
    */
    enum Position { TopStart, TopCenter, TopEnd, BottomStart, BottomCenter, BottomEnd }

    /*! \qmlproperty int ToastArea::position \brief The anchoring corner; see \l Position. Defaults to \c ToastArea.BottomEnd. */
    property int position: ToastArea.BottomEnd
    /*! \qmlproperty int ToastArea::duration \brief Default dwell time in milliseconds before auto-dismiss; \c opts.duration overrides per toast. Defaults to 4000. */
    property int duration: 4000
    /*! \qmlproperty int ToastArea::gap \brief Spacing between stacked toasts. Defaults to \l Theme::space2. */
    property int gap: Theme.space2
    /*! \qmlproperty int ToastArea::edgeMargin \brief Padding between the stack and the anchored edges. Defaults to \l Theme::space4. */
    property int edgeMargin: Theme.space4

    /*!
        \qmlsignal ToastArea::actionTriggered(int uid)
        Emitted when a toast's action button is clicked. \a uid is the identifier
        returned by \l show (and the convenience methods).
    */
    signal actionTriggered(int uid)

    readonly property bool _isRight: position === ToastArea.TopEnd || position === ToastArea.BottomEnd
    readonly property bool _isLeft: position === ToastArea.TopStart || position === ToastArea.BottomStart
    readonly property bool _isTop: position === ToastArea.TopStart || position === ToastArea.TopCenter
                                   || position === ToastArea.TopEnd
    // Enter offset: side positions slide horizontally; centered ones slide vertically.
    readonly property real _enterDx: _isRight ? 40 : (_isLeft ? -40 : 0)
    readonly property real _enterDy: _enterDx !== 0 ? 0 : (_isTop ? -20 : 20)

    property int _seq: 0

    ListModel { id: toastModel }

    /*!
        \qmlmethod int ToastArea::show(string text, var opts)
        Pushes a toast whose title is \a text and returns its unique \c uid.
        \a opts is an optional object supporting \c type (a \l Toast::Type value),
        \c description, \c actionText, and \c duration (ms).
    */
    function show(text, opts) {
        opts = opts || {}
        var uid = _seq++
        toastModel.append({
            uid: uid,
            ttype: opts.type === undefined ? Toast.Default : opts.type,
            title: text === undefined ? "" : text,
            description: opts.description === undefined ? "" : opts.description,
            actionText: opts.actionText === undefined ? "" : opts.actionText,
            duration: opts.duration === undefined ? area.duration : opts.duration
        })
        return uid
    }
    /*! \qmlmethod int ToastArea::success(string text, var opts) \brief Shows a \c Toast.Success toast; see \l show. */
    function success(text, opts) { opts = opts || {}; opts.type = Toast.Success; return show(text, opts) }
    /*! \qmlmethod int ToastArea::info(string text, var opts) \brief Shows a \c Toast.Info toast; see \l show. */
    function info(text, opts)    { opts = opts || {}; opts.type = Toast.Info;    return show(text, opts) }
    /*! \qmlmethod int ToastArea::warning(string text, var opts) \brief Shows a \c Toast.Warning toast; see \l show. */
    function warning(text, opts) { opts = opts || {}; opts.type = Toast.Warning; return show(text, opts) }
    /*! \qmlmethod int ToastArea::error(string text, var opts) \brief Shows a \c Toast.Error toast; see \l show. */
    function error(text, opts)   { opts = opts || {}; opts.type = Toast.Error;   return show(text, opts) }
    /*! \qmlmethod int ToastArea::loading(string text, var opts) \brief Shows a \c Toast.Loading toast; see \l show. */
    function loading(text, opts) { opts = opts || {}; opts.type = Toast.Loading; return show(text, opts) }

    /*! \qmlmethod void ToastArea::dismissAll() \brief Immediately clears all toasts. */
    function dismissAll() { toastModel.clear() }

    // Remove by uid (called after the exit animation finishes).
    function _remove(uid) {
        for (var i = 0; i < toastModel.count; i++) {
            if (toastModel.get(i).uid === uid) { toastModel.remove(i); return }
        }
    }

    Column {
        id: stack
        spacing: area.gap

        // Snap to the corner selected by position.
        anchors.top: area._isTop ? parent.top : undefined
        anchors.bottom: area._isTop ? undefined : parent.bottom
        anchors.left: area._isLeft ? parent.left : undefined
        anchors.right: area._isRight ? parent.right : undefined
        anchors.horizontalCenter: (!area._isLeft && !area._isRight) ? parent.horizontalCenter : undefined
        anchors.margins: area.edgeMargin

        Repeater {
            model: toastModel

            delegate: Item {
                id: slot
                required property var model

                width: card.implicitWidth
                height: card.implicitHeight
                clip: false

                Toast {
                    id: card
                    type: slot.model.ttype
                    title: slot.model.title
                    description: slot.model.description
                    actionText: slot.model.actionText
                    onActionTriggered: {
                        area.actionTriggered(slot.model.uid)
                        slot.close()
                    }
                }

                // Enter: slide in from the offset position + fade in.
                opacity: 0
                transform: Translate { id: shift; x: area._enterDx; y: area._enterDy }
                Component.onCompleted: enterAnim.start()

                ParallelAnimation {
                    id: enterAnim
                    NumberAnimation { target: slot; property: "opacity"; to: 1; duration: Theme.durBase }
                    NumberAnimation { target: shift; property: "x"; to: 0; duration: Theme.durBase; easing.type: Easing.OutCubic }
                    NumberAnimation { target: shift; property: "y"; to: 0; duration: Theme.durBase; easing.type: Easing.OutCubic }
                }

                // Exit: fade out + slide back, then remove from the model.
                ParallelAnimation {
                    id: exitAnim
                    NumberAnimation { target: slot; property: "opacity"; to: 0; duration: Theme.durFast }
                    NumberAnimation { target: shift; property: "x"; to: area._enterDx; duration: Theme.durFast; easing.type: Easing.InCubic }
                    onFinished: area._remove(slot.model.uid)
                }

                function close() {
                    dwell.stop()
                    exitAnim.start()
                }

                // Auto-dismiss timer.
                Timer {
                    id: dwell
                    interval: slot.model.duration
                    running: true
                    onTriggered: slot.close()
                }

                // Clicking the toast body (outside the action button) dismisses early.
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    z: -1
                    onClicked: slot.close()
                }
            }
        }
    }
}
