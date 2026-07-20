import QtQuick

// shadcn Sonner —— toast 容器/管理器(组件内自管理,无需全局单例)。
// 在某个锚点角落堆叠多条 Toast,自动消失,进入滑入+淡入、离场淡出。
// 用法:放一个 ToastArea(通常 anchors.fill 覆盖某区域),调用 area.show("文本", { ... })。
// 便利方法:success/info/warning/error(text, opts)。opts 支持 description / actionText / duration。
Item {
    id: area

    enum Position { TopLeft, TopCenter, TopRight, BottomLeft, BottomCenter, BottomRight }

    property int position: ToastArea.BottomRight
    property int duration: 4000                 // 默认停留(ms),opts.duration 可覆盖
    property int gap: Theme.space2              // 相邻 toast 间距
    property int edgeMargin: Theme.space4       // 距锚点边缘的留白

    // 供动作按钮回调(uid 为该 toast 的唯一标识)。
    signal actionTriggered(int uid)

    readonly property bool _isRight: position === ToastArea.TopRight || position === ToastArea.BottomRight
    readonly property bool _isLeft: position === ToastArea.TopLeft || position === ToastArea.BottomLeft
    readonly property bool _isTop: position === ToastArea.TopLeft || position === ToastArea.TopCenter
                                   || position === ToastArea.TopRight
    // 进入偏移:左右侧向水平滑入;居中则纵向滑入。
    readonly property real _enterDx: _isRight ? 40 : (_isLeft ? -40 : 0)
    readonly property real _enterDy: _enterDx !== 0 ? 0 : (_isTop ? -20 : 20)

    property int _seq: 0

    ListModel { id: toastModel }

    // 弹出一条 toast。opts: { type, description, actionText, duration }。返回本条 uid。
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
    function success(text, opts) { opts = opts || {}; opts.type = Toast.Success; return show(text, opts) }
    function info(text, opts)    { opts = opts || {}; opts.type = Toast.Info;    return show(text, opts) }
    function warning(text, opts) { opts = opts || {}; opts.type = Toast.Warning; return show(text, opts) }
    function error(text, opts)   { opts = opts || {}; opts.type = Toast.Error;   return show(text, opts) }
    function loading(text, opts) { opts = opts || {}; opts.type = Toast.Loading; return show(text, opts) }

    function dismissAll() { toastModel.clear() }

    // 按 uid 移除(离场动画结束后调用)。
    function _remove(uid) {
        for (var i = 0; i < toastModel.count; i++) {
            if (toastModel.get(i).uid === uid) { toastModel.remove(i); return }
        }
    }

    Column {
        id: stack
        spacing: area.gap

        // 依 position 贴合对应角落。
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

                // 进入:从偏移位置滑入 + 淡入。
                opacity: 0
                transform: Translate { id: shift; x: area._enterDx; y: area._enterDy }
                Component.onCompleted: enterAnim.start()

                ParallelAnimation {
                    id: enterAnim
                    NumberAnimation { target: slot; property: "opacity"; to: 1; duration: Theme.durBase }
                    NumberAnimation { target: shift; property: "x"; to: 0; duration: Theme.durBase; easing.type: Easing.OutCubic }
                    NumberAnimation { target: shift; property: "y"; to: 0; duration: Theme.durBase; easing.type: Easing.OutCubic }
                }

                // 离场:淡出 + 轻微滑回,结束后从模型移除。
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

                // 自动消失计时。
                Timer {
                    id: dwell
                    interval: slot.model.duration
                    running: true
                    onTriggered: slot.close()
                }

                // 点击 toast 主体(动作按钮除外)可提前关闭。
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
