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
    property string currentPage: "PageButton.qml"
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
        { id: "accordion",        label: "Accordion",        page: "PageAccordion.qml" },
        { id: "alert",            label: "Alert",            page: "PageAlert.qml" },
        { id: "alert-dialog",     label: "Alert Dialog",     page: "PageAlertDialog.qml" },
        { id: "aspect-ratio",     label: "Aspect Ratio",     page: "PageAspectRatio.qml" },
        { id: "attachment",       label: "Attachment",       page: "PageAttachment.qml" },
        { id: "avatar",           label: "Avatar",           page: "PageAvatar.qml" },
        { id: "badge",            label: "Badge",            page: "PageBadge.qml" },
        { id: "breadcrumb",       label: "Breadcrumb",       page: "PageBreadcrumb.qml" },
        { id: "bubble",           label: "Bubble",           page: "PageBubble.qml" },
        { id: "button",           label: "Button",           page: "PageButton.qml" },
        { id: "button-group",     label: "Button Group",     page: "PageButtonGroup.qml" },
        { id: "calendar",         label: "Calendar",         page: "PageCalendar.qml" },
        { id: "card",             label: "Card",             page: "PageCard.qml" },
        { id: "carousel",         label: "Carousel",         page: "PageCarousel.qml" },
        { id: "chart",            label: "Chart",            page: "PageChart.qml" },
        { id: "checkbox",         label: "Checkbox",         page: "PageCheckbox.qml" },
        { id: "collapsible",      label: "Collapsible",      page: "PageCollapsible.qml" },
        { id: "combobox",         label: "Combobox",         page: "PageCombobox.qml" },
        { id: "command",          label: "Command",          page: "PageCommand.qml" },
        { id: "context-menu",     label: "Context Menu",     page: "PageContextMenu.qml" },
        { id: "data-table",       label: "Data Table",       page: "PageDataTable.qml" },
        { id: "date-picker",      label: "Date Picker",      page: "PageDatePicker.qml" },
        { id: "dialog",           label: "Dialog",           page: "PageDialog.qml" },
        { id: "drawer",           label: "Drawer",           page: "PageDrawer.qml" },
        { id: "dropdown-menu",    label: "Dropdown Menu",    page: "PageMenu.qml" },
        { id: "empty",            label: "Empty",            page: "PageEmpty.qml" },
        { id: "field",            label: "Field",            page: "PageField.qml" },
        { id: "form",             label: "Form",             page: "PageForm.qml" },
        { id: "hover-card",       label: "Hover Card",       page: "PageHoverCard.qml" },
        { id: "input",            label: "Input",            page: "PageInput.qml" },
        { id: "input-group",      label: "Input Group",      page: "PageInputGroup.qml" },
        { id: "input-otp",        label: "Input OTP",        page: "PageInputOtp.qml" },
        { id: "item",             label: "Item",             page: "PageItem.qml" },
        { id: "kbd",              label: "Kbd",              page: "PageKbd.qml" },
        { id: "label",            label: "Label",            page: "PageLabel.qml" },
        { id: "marker",           label: "Marker",           page: "PageMarker.qml" },
        { id: "menubar",          label: "Menubar",          page: "PageMenubar.qml" },
        { id: "message",          label: "Message",          page: "PageMessage.qml" },
        { id: "message-scroller", label: "Message Scroller", page: "PageMessageScroller.qml" },
        { id: "native-select",    label: "Native Select",    page: "PageNativeSelect.qml" },
        { id: "navigation-menu",  label: "Navigation Menu",  page: "PageNavigationMenu.qml" },
        { id: "pagination",       label: "Pagination",       page: "PagePagination.qml" },
        { id: "popover",          label: "Popover",          page: "PagePopover.qml" },
        { id: "progress",         label: "Progress",         page: "PageProgress.qml" },
        { id: "radio-group",      label: "Radio Group",      page: "PageRadioGroup.qml" },
        { id: "resizable",        label: "Resizable",        page: "PageResizable.qml" },
        { id: "scroll-area",      label: "Scroll Area",      page: "PageScrollArea.qml" },
        { id: "select",           label: "Select",           page: "PageSelect.qml" },
        { id: "separator",        label: "Separator",        page: "PageSeparator.qml" },
        { id: "sheet",            label: "Sheet",            page: "PageSheet.qml" },
        { id: "sidebar",          label: "Sidebar",          page: "PageSidebar.qml" },
        { id: "skeleton",         label: "Skeleton",         page: "PageSkeleton.qml" },
        { id: "slider",           label: "Slider",           page: "PageSlider.qml" },
        { id: "sonner",           label: "Sonner",           page: "PageSonner.qml" },
        { id: "spinner",          label: "Spinner",          page: "PageSpinner.qml" },
        { id: "switch",           label: "Switch",           page: "PageSwitch.qml" },
        { id: "table",            label: "Table",            page: "PageTable.qml" },
        { id: "tabs",             label: "Tabs",             page: "PageTabs.qml" },
        { id: "textarea",         label: "Textarea",         page: "PageTextarea.qml" },
        { id: "toggle",           label: "Toggle",           page: "PageToggle.qml" },
        { id: "toggle-group",     label: "Toggle Group",     page: "PageToggleGroup.qml" },
        { id: "tooltip",          label: "Tooltip",          page: "PageTooltip.qml" },
        { id: "typography",       label: "Typography",       page: "PageTypography.qml" }
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
