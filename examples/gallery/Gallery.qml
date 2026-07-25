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
        { id: "theme-customizer", label: "Theme Customizer", page: "PageThemeCustomizer.qml" },
        { id: "accordion",        label: "Accordion",        page: "demos/accordion/PageAccordion.qml" },
        { id: "alert",            label: "Alert",            page: "demos/alert/PageAlert.qml" },
        { id: "alert-dialog",     label: "Alert Dialog",     page: "demos/alert-dialog/PageAlertDialog.qml" },
        { id: "aspect-ratio",     label: "Aspect Ratio",     page: "demos/aspect-ratio/PageAspectRatio.qml" },
        { id: "attachment",       label: "Attachment",       page: "demos/attachment/PageAttachment.qml" },
        { id: "avatar",           label: "Avatar",           page: "demos/avatar/PageAvatar.qml" },
        { id: "badge",            label: "Badge",            page: "demos/badge/PageBadge.qml" },
        { id: "breadcrumb",       label: "Breadcrumb",       page: "demos/breadcrumb/PageBreadcrumb.qml" },
        { id: "bubble",           label: "Bubble",           page: "demos/bubble/PageBubble.qml" },
        { id: "button",           label: "Button",           page: "demos/button/PageButton.qml" },
        { id: "button-group",     label: "Button Group",     page: "demos/button-group/PageButtonGroup.qml" },
        { id: "calendar",         label: "Calendar",         page: "demos/calendar/PageCalendar.qml" },
        { id: "card",             label: "Card",             page: "demos/card/PageCard.qml" },
        { id: "carousel",         label: "Carousel",         page: "demos/carousel/PageCarousel.qml" },
        { id: "chart",            label: "Chart",            page: "demos/chart/PageChart.qml" },
        { id: "checkbox",         label: "Checkbox",         page: "demos/checkbox/PageCheckbox.qml" },
        { id: "collapsible",      label: "Collapsible",      page: "demos/collapsible/PageCollapsible.qml" },
        { id: "combobox",         label: "Combobox",         page: "demos/combobox/PageCombobox.qml" },
        { id: "command",          label: "Command",          page: "demos/command/PageCommand.qml" },
        { id: "context-menu",     label: "Context Menu",     page: "demos/context-menu/PageContextMenu.qml" },
        { id: "data-table",       label: "Data Table",       page: "demos/data-table/PageDataTable.qml" },
        { id: "date-picker",      label: "Date Picker",      page: "demos/date-picker/PageDatePicker.qml" },
        { id: "dialog",           label: "Dialog",           page: "demos/dialog/PageDialog.qml" },
        { id: "drawer",           label: "Drawer",           page: "demos/drawer/PageDrawer.qml" },
        { id: "dropdown-menu",    label: "Dropdown Menu",    page: "demos/menu/PageMenu.qml" },
        { id: "empty",            label: "Empty",            page: "demos/empty/PageEmpty.qml" },
        { id: "field",            label: "Field",            page: "demos/field/PageField.qml" },
        { id: "form",             label: "Form",             page: "demos/form/PageForm.qml" },
        { id: "hover-card",       label: "Hover Card",       page: "demos/hover-card/PageHoverCard.qml" },
        { id: "input",            label: "Input",            page: "demos/input/PageInput.qml" },
        { id: "input-group",      label: "Input Group",      page: "demos/input-group/PageInputGroup.qml" },
        { id: "input-otp",        label: "Input OTP",        page: "demos/input-otp/PageInputOtp.qml" },
        { id: "item",             label: "Item",             page: "demos/item/PageItem.qml" },
        { id: "kbd",              label: "Kbd",              page: "demos/kbd/PageKbd.qml" },
        { id: "label",            label: "Label",            page: "demos/label/PageLabel.qml" },
        { id: "marker",           label: "Marker",           page: "demos/marker/PageMarker.qml" },
        { id: "menubar",          label: "Menubar",          page: "demos/menubar/PageMenubar.qml" },
        { id: "message",          label: "Message",          page: "demos/message/PageMessage.qml" },
        { id: "message-scroller", label: "Message Scroller", page: "demos/message-scroller/PageMessageScroller.qml" },
        { id: "native-select",    label: "Native Select",    page: "demos/native-select/PageNativeSelect.qml" },
        { id: "navigation-menu",  label: "Navigation Menu",  page: "demos/navigation-menu/PageNavigationMenu.qml" },
        { id: "pagination",       label: "Pagination",       page: "demos/pagination/PagePagination.qml" },
        { id: "popover",          label: "Popover",          page: "demos/popover/PagePopover.qml" },
        { id: "progress",         label: "Progress",         page: "demos/progress/PageProgress.qml" },
        { id: "radio-group",      label: "Radio Group",      page: "demos/radio-group/PageRadioGroup.qml" },
        { id: "resizable",        label: "Resizable",        page: "demos/resizable/PageResizable.qml" },
        { id: "scroll-area",      label: "Scroll Area",      page: "demos/scroll-area/PageScrollArea.qml" },
        { id: "select",           label: "Select",           page: "demos/select/PageSelect.qml" },
        { id: "separator",        label: "Separator",        page: "demos/separator/PageSeparator.qml" },
        { id: "sheet",            label: "Sheet",            page: "demos/sheet/PageSheet.qml" },
        { id: "sidebar",          label: "Sidebar",          page: "demos/sidebar/PageSidebar.qml" },
        { id: "skeleton",         label: "Skeleton",         page: "demos/skeleton/PageSkeleton.qml" },
        { id: "slider",           label: "Slider",           page: "demos/slider/PageSlider.qml" },
        { id: "sonner",           label: "Sonner",           page: "demos/sonner/PageSonner.qml" },
        { id: "spinner",          label: "Spinner",          page: "demos/spinner/PageSpinner.qml" },
        { id: "switch",           label: "Switch",           page: "demos/switch/PageSwitch.qml" },
        { id: "table",            label: "Table",            page: "demos/table/PageTable.qml" },
        { id: "tabs",             label: "Tabs",             page: "demos/tabs/PageTabs.qml" },
        { id: "textarea",         label: "Textarea",         page: "demos/textarea/PageTextarea.qml" },
        { id: "toggle",           label: "Toggle",           page: "demos/toggle/PageToggle.qml" },
        { id: "toggle-group",     label: "Toggle Group",     page: "demos/toggle-group/PageToggleGroup.qml" },
        { id: "tooltip",          label: "Tooltip",          page: "demos/tooltip/PageTooltip.qml" },
        { id: "typography",       label: "Typography",       page: "demos/typography/PageTypography.qml" }
    ]

    function select(item) {
        win.currentId = item.id
        win.currentLabel = item.label
        win.currentPage = item.page
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
                    text: "shadcn/ui"
                    color: Theme.foreground
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    text: "QML"
                    color: Theme.mutedForeground
                    font.pixelSize: 13
                }
                Item { Layout.fillWidth: true }
                IconButton {
                    iconName: Theme.dark ? "sun" : "moon"
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

            // ==== 右侧内容区 ====
            ScrollView {
                id: contentScroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                // 内容宽度锁定到视口可用宽 → 永不产生横向滚动,页面随窗口宽度自适应收缩。
                contentWidth: availableWidth

                Item {
                    // 随视口宽度自适应;窄屏时减小左右留白,内容最大宽 760。
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
