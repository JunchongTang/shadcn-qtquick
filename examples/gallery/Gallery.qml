import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls.Basic as QC
import Shadcn
import LucideIcons

// shadcn/QML 文档站 —— 仿 ui.shadcn.com/docs/components 外观:
// 顶栏 + 左侧组件导航 + 右侧组件详情页(Loader 路由)。
// 导航列出官方 registry 组件全集,已实现的挂真实页面,未实现的落占位页,
// 便于逐项对比"哪些完成 / 哪些未完成"。
Window {
    id: win
    width: 1180
    height: 820
    visible: true
    color: Theme.background
    title: qsTr("shadcn/ui — QML")

    // 当前选中组件 id 与其页面文件(空 → 占位页)。
    property string currentId: "button"
    property string currentPage: "demos/button/PageButton.qml"
    property string currentLabel: "Button"

    // 窄屏(< 860)收起侧栏,顶栏出汉堡按钮开抽屉,让内容区拿到全部宽度。
    readonly property bool compact: width < 860

    // 不可见的初始焦点占位:满足"场景需有 activeFocus,Tab 导航才启动"的前提,但自身无焦点环。
    // 启动焦点落这里 → 首次 Tab 才把焦点送入真正的可交互控件(那时才按键盘 focus-visible 显环)。
    Item { id: kbStart; width: 0; height: 0 }

    Component.onCompleted: {
        Theme.dark = appStartDark
        Qt.callLater(function () { kbStart.forceActiveFocus() })
    }

    // ==== 导航数据:官方 Components 列表(含实现状态)========================
    // page 非空即为已实现;label 用于详情页标题。
    readonly property var nav: [
        { id: "theme-customizer", label: qsTr("Theme Customizer"), page: "PageThemeCustomizer.qml" },
        { id: "accordion",        label: qsTr("Accordion"),        page: "demos/accordion/PageAccordion.qml" },
        { id: "alert",            label: qsTr("Alert"),            page: "demos/alert/PageAlert.qml" },
        { id: "alert-dialog",     label: qsTr("Alert Dialog"),     page: "demos/alert-dialog/PageAlertDialog.qml" },
        { id: "aspect-ratio",     label: qsTr("Aspect Ratio"),     page: "demos/aspect-ratio/PageAspectRatio.qml" },
        { id: "attachment",       label: qsTr("Attachment"),       page: "demos/attachment/PageAttachment.qml" },
        { id: "avatar",           label: qsTr("Avatar"),           page: "demos/avatar/PageAvatar.qml" },
        { id: "badge",            label: qsTr("Badge"),            page: "demos/badge/PageBadge.qml" },
        { id: "breadcrumb",       label: qsTr("Breadcrumb"),       page: "demos/breadcrumb/PageBreadcrumb.qml" },
        { id: "bubble",           label: qsTr("Bubble"),           page: "demos/bubble/PageBubble.qml" },
        { id: "button",           label: qsTr("Button"),           page: "demos/button/PageButton.qml" },
        { id: "button-group",     label: qsTr("Button Group"),     page: "demos/button-group/PageButtonGroup.qml" },
        { id: "calendar",         label: qsTr("Calendar"),         page: "demos/calendar/PageCalendar.qml" },
        { id: "card",             label: qsTr("Card"),             page: "demos/card/PageCard.qml" },
        { id: "carousel",         label: qsTr("Carousel"),         page: "demos/carousel/PageCarousel.qml" },
        { id: "chart",            label: qsTr("Chart"),            page: "demos/chart/PageChart.qml" },
        { id: "checkbox",         label: qsTr("Checkbox"),         page: "demos/checkbox/PageCheckbox.qml" },
        { id: "collapsible",      label: qsTr("Collapsible"),      page: "demos/collapsible/PageCollapsible.qml" },
        { id: "combobox",         label: qsTr("Combobox"),         page: "demos/combobox/PageCombobox.qml" },
        { id: "command",          label: qsTr("Command"),          page: "demos/command/PageCommand.qml" },
        { id: "context-menu",     label: qsTr("Context Menu"),     page: "demos/context-menu/PageContextMenu.qml" },
        { id: "data-table",       label: qsTr("Data Table"),       page: "demos/data-table/PageDataTable.qml" },
        { id: "date-picker",      label: qsTr("Date Picker"),      page: "demos/date-picker/PageDatePicker.qml" },
        { id: "dialog",           label: qsTr("Dialog"),           page: "demos/dialog/PageDialog.qml" },
        { id: "drawer",           label: qsTr("Drawer"),           page: "demos/drawer/PageDrawer.qml" },
        { id: "dropdown-menu",    label: qsTr("Dropdown Menu"),    page: "demos/menu/PageMenu.qml" },
        { id: "empty",            label: qsTr("Empty"),            page: "demos/empty/PageEmpty.qml" },
        { id: "field",            label: qsTr("Field"),            page: "demos/field/PageField.qml" },
        { id: "form",             label: qsTr("Form"),             page: "demos/form/PageForm.qml" },
        { id: "hover-card",       label: qsTr("Hover Card"),       page: "demos/hover-card/PageHoverCard.qml" },
        { id: "input",            label: qsTr("Input"),            page: "demos/input/PageInput.qml" },
        { id: "input-group",      label: qsTr("Input Group"),      page: "demos/input-group/PageInputGroup.qml" },
        { id: "input-otp",        label: qsTr("Input OTP"),        page: "demos/input-otp/PageInputOtp.qml" },
        { id: "item",             label: qsTr("Item"),             page: "demos/item/PageItem.qml" },
        { id: "kbd",              label: qsTr("Kbd"),              page: "demos/kbd/PageKbd.qml" },
        { id: "label",            label: qsTr("Label"),            page: "demos/label/PageLabel.qml" },
        { id: "marker",           label: qsTr("Marker"),           page: "demos/marker/PageMarker.qml" },
        { id: "menubar",          label: qsTr("Menubar"),          page: "demos/menubar/PageMenubar.qml" },
        { id: "message",          label: qsTr("Message"),          page: "demos/message/PageMessage.qml" },
        { id: "message-scroller", label: qsTr("Message Scroller"), page: "demos/message-scroller/PageMessageScroller.qml" },
        { id: "native-select",    label: qsTr("Native Select"),    page: "demos/native-select/PageNativeSelect.qml" },
        { id: "navigation-menu",  label: qsTr("Navigation Menu"),  page: "demos/navigation-menu/PageNavigationMenu.qml" },
        { id: "pagination",       label: qsTr("Pagination"),       page: "demos/pagination/PagePagination.qml" },
        { id: "popover",          label: qsTr("Popover"),          page: "demos/popover/PagePopover.qml" },
        { id: "progress",         label: qsTr("Progress"),         page: "demos/progress/PageProgress.qml" },
        { id: "radio-group",      label: qsTr("Radio Group"),      page: "demos/radio-group/PageRadioGroup.qml" },
        { id: "resizable",        label: qsTr("Resizable"),        page: "demos/resizable/PageResizable.qml" },
        { id: "scroll-area",      label: qsTr("Scroll Area"),      page: "demos/scroll-area/PageScrollArea.qml" },
        { id: "select",           label: qsTr("Select"),           page: "demos/select/PageSelect.qml" },
        { id: "separator",        label: qsTr("Separator"),        page: "demos/separator/PageSeparator.qml" },
        { id: "sheet",            label: qsTr("Sheet"),            page: "demos/sheet/PageSheet.qml" },
        { id: "sidebar",          label: qsTr("Sidebar"),          page: "demos/sidebar/PageSidebar.qml" },
        { id: "skeleton",         label: qsTr("Skeleton"),         page: "demos/skeleton/PageSkeleton.qml" },
        { id: "slider",           label: qsTr("Slider"),           page: "demos/slider/PageSlider.qml" },
        { id: "sonner",           label: qsTr("Sonner"),           page: "demos/sonner/PageSonner.qml" },
        { id: "spinner",          label: qsTr("Spinner"),          page: "demos/spinner/PageSpinner.qml" },
        { id: "switch",           label: qsTr("Switch"),           page: "demos/switch/PageSwitch.qml" },
        { id: "table",            label: qsTr("Table"),            page: "demos/table/PageTable.qml" },
        { id: "tabs",             label: qsTr("Tabs"),             page: "demos/tabs/PageTabs.qml" },
        { id: "textarea",         label: qsTr("Textarea"),         page: "demos/textarea/PageTextarea.qml" },
        { id: "toggle",           label: qsTr("Toggle"),           page: "demos/toggle/PageToggle.qml" },
        { id: "toggle-group",     label: qsTr("Toggle Group"),     page: "demos/toggle-group/PageToggleGroup.qml" },
        { id: "tooltip",          label: qsTr("Tooltip"),          page: "demos/tooltip/PageTooltip.qml" },
        { id: "typography",       label: qsTr("Typography"),       page: "demos/typography/PageTypography.qml" }
    ]

    function select(item) {
        win.currentId = item.id
        win.currentLabel = item.label
        win.currentPage = item.page
    }

    // Map a nav id to its generated qdoc page (qml-shadcn-<type>.html). Most ids
    // map by dropping hyphens; a few point at a differently-named primary type.
    // Returns "" when the entry has no API page (e.g. the theme customizer).
    function apiFile(id) {
        var override = {
            "data-table": "table", "item": "shaditem", "sonner": "toast",
            "dropdown-menu": "menu", "theme-customizer": ""
        }
        var slug = (id in override) ? override[id] : id.replace(/-/g, "")
        return slug === "" ? "" : "qml-shadcn-" + slug + ".html"
    }

    // 供示例卡「复制路径」调用:弹一条 toast 显示已复制的路径,短暂停留后自动消失。
    function notifyCopied(path) {
        toaster.success(qsTr("Copied to clipboard"), { "description": path, "duration": 2000 })
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ==== 顶栏 ====
        Item {
            Layout.fillWidth: true
            implicitHeight: 52

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: win.compact ? 8 : 20
                anchors.rightMargin: 16
                spacing: 10

                // 汉堡按钮:窄屏时出现,点开侧栏抽屉。
                IconButton {
                    visible: win.compact
                    iconName: "menu"
                    variant: IconButton.Ghost
                    onClicked: navDrawer.open()
                }
                Text {
                    text: qsTr("shadcn/ui")
                    color: Theme.foreground
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    text: qsTr("QML")
                    color: Theme.mutedForeground
                    font.pixelSize: 13
                }
                Item { Layout.fillWidth: true }
                IconButton {
                    iconName: Theme.dark ? qsTr("sun") : qsTr("moon")
                    variant: IconButton.Ghost
                    onClicked: Theme.dark = !Theme.dark
                }
            }
            // border-b
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.border
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // ==== 左侧导航(宽屏内联;窄屏收起,改用抽屉)====
            DocsSidebar {
                id: sidebar
                visible: !win.compact
                Layout.preferredWidth: win.compact ? 0 : 240
                Layout.fillHeight: true
                model: win.nav
                currentId: win.currentId
                onItemClicked: (item) => win.select(item)
            }

            // ==== 右侧内容区:顶部工具条 + Preview(示例卡片)/ API(内嵌 qdoc 文档)====
            ColumnLayout {
                id: contentArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                property bool showApi: false
                readonly property string apiHtml: win.apiFile(win.currentId)
                // 仅当文档已生成(docsBaseUrl 非空)且该组件有对应页时,才提供 API 切换。
                readonly property bool apiAvail: (typeof docsBaseUrl !== "undefined")
                                                 && docsBaseUrl !== "" && apiHtml !== ""
                onApiAvailChanged: if (!apiAvail) showApi = false
                // 切换组件时回到 Preview。
                Connections { target: win; function onCurrentIdChanged() { contentArea.showApi = false } }

                // ---- 顶部工具条:左(仅 API 模式)后退/刷新/外部打开;右 Preview|API 分段 ----
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 48
                    visible: contentArea.apiAvail

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 16
                        spacing: 6

                        IconButton {
                            visible: contentArea.showApi
                            iconName: "arrow-left"
                            variant: IconButton.Ghost
                            size: IconButton.Small
                            enabled: apiLoader.item ? apiLoader.item.canGoBack : false
                            onClicked: if (apiLoader.item) apiLoader.item.goBack()
                        }
                        IconButton {
                            visible: contentArea.showApi
                            iconName: "rotate-cw"
                            variant: IconButton.Ghost
                            size: IconButton.Small
                            onClicked: if (apiLoader.item) apiLoader.item.reload()
                        }
                        IconButton {
                            visible: contentArea.showApi
                            iconName: "external-link"
                            variant: IconButton.Ghost
                            size: IconButton.Small
                            onClicked: if (apiLoader.item) Qt.openUrlExternally(apiLoader.item.currentUrl)
                        }

                        Item { Layout.fillWidth: true }

                        // Preview | API 分段
                        Rectangle {
                            radius: Theme.radiusMd
                            color: Theme.background
                            border.width: 1
                            border.color: Theme.border
                            implicitWidth: segRow.implicitWidth + 6
                            implicitHeight: segRow.implicitHeight + 6

                            RowLayout {
                                id: segRow
                                anchors.centerIn: parent
                                spacing: 2
                                Button {
                                    text: qsTr("Preview")
                                    size: Button.Sm
                                    variant: contentArea.showApi ? Button.Ghost : Button.Secondary
                                    onClicked: contentArea.showApi = false
                                }
                                Button {
                                    text: qsTr("API")
                                    size: Button.Sm
                                    variant: contentArea.showApi ? Button.Secondary : Button.Ghost
                                    onClicked: contentArea.showApi = true
                                }
                            }
                        }
                    }
                    // 工具条底部分隔线
                    Rectangle {
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                        height: 1
                        color: Theme.border
                    }
                }

                // ---- Preview:示例卡片 ----
                ScrollView {
                    id: contentScroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: !contentArea.showApi
                    clip: true
                    // 内容宽度锁定到视口可用宽 → 永不产生横向滚动,页面随窗口宽度自适应收缩。
                    contentWidth: availableWidth

                    Item {
                        width: contentScroll.availableWidth
                        implicitHeight: pageLoader.implicitHeight + 2 * pageLoader.y

                        Loader {
                            id: pageLoader
                            readonly property int pad: parent.width < 560 ? 16 : 40
                            x: pad
                            y: pad
                            // 填满视口可用宽(不再封顶 760),使卡片随窗口变宽而变宽。
                            width: Math.max(0, parent.width - 2 * pad)
                            source: win.currentPage !== "" ? win.currentPage : "PagePlaceholder.qml"
                            // 把标题/描述传给页面骨架
                            onLoaded: {
                                if (item && item.hasOwnProperty("componentLabel"))
                                    item.componentLabel = win.currentLabel
                            }
                        }
                    }
                }

                // ---- API:内嵌 qdoc 文档(懒加载,仅在切到 API 时实例化)----
                Loader {
                    id: apiLoader
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    active: contentArea.showApi
                    visible: contentArea.showApi
                    source: Qt.resolvedUrl("ApiDocsView.qml")
                    onLoaded: item.pageUrl = docsBaseUrl + contentArea.apiHtml
                }
            }
        }
    }

    // ==== 窄屏侧栏抽屉(汉堡按钮打开;选中后自动关闭)====
    QC.Drawer {
        id: navDrawer
        edge: Qt.LeftEdge
        width: 260
        height: win.height
        // 若窗口在抽屉打开时变宽到非 compact,自动收起。
        Connections { target: win; function onCompactChanged() { if (!win.compact) navDrawer.close() } }

        background: Rectangle { color: Theme.background }

        DocsSidebar {
            anchors.fill: parent
            model: win.nav
            currentId: win.currentId
            onItemClicked: (item) => { win.select(item); navDrawer.close() }
        }
    }

    // ==== 全局 Toast 层(覆盖全窗,右下角堆叠)====
    ToastArea {
        id: toaster
        anchors.fill: parent
        position: ToastArea.BottomEnd
        z: 1000
    }
}
