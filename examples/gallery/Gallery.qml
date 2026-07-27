import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls.Basic as QC
import Shadcn
import LucideIcons

// shadcn/QML docs site — mimics the ui.shadcn.com/docs/components look:
// top bar + left component navigation + right component detail page (Loader routing).
// The nav lists the full official registry component set; implemented ones mount real pages, unimplemented ones fall back to a placeholder page,
// making it easy to compare item by item "which are done / which are not".
Window {
    id: win
    width: 1180
    height: 820
    visible: true
    color: Theme.background
    title: qsTr("Shadcn - QtQuick")

    // Currently selected component id and its page file (empty → placeholder page).
    property string currentId: "button"
    property string currentPage: "demos/button/PageButton.qml"
    property string currentLabel: "Button"

    // Top-bar main navigation's current section: components | charts | create.
    property string section: "components"

    // Top-bar nav item: plain-text tab, active state uses foreground color + medium weight.
    component NavTab: Text {
        id: navTab
        property bool active: false
        signal clicked()
        color: active ? Theme.foreground : Theme.mutedForeground
        font.pixelSize: 14
        font.weight: active ? Font.Medium : Font.Normal
        verticalAlignment: Text.AlignVCenter
        HoverHandler { cursorShape: Qt.PointingHandCursor }
        TapHandler { onTapped: navTab.clicked() }
    }

    // Narrow screens (< 860) collapse the sidebar; the top bar shows a hamburger button to open a drawer, giving the content area full width.
    readonly property bool compact: width < 860

    // Invisible initial focus placeholder: satisfies the "the scene needs activeFocus before Tab navigation starts" prerequisite, but has no focus ring itself.
    // Startup focus lands here → the first Tab then sends focus into a real interactive control (only then does keyboard focus-visible show a ring).
    Item { id: kbStart; width: 0; height: 0 }

    Component.onCompleted: {
        Theme.dark = appStartDark
        Qt.callLater(function () { kbStart.forceActiveFocus() })
    }

    // ==== Nav data: official Components list (with implementation status) ========================
    // A non-empty page means implemented; label is used for the detail page title.
    readonly property var nav: [
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

    // Called by the example card's "copy path": show a toast displaying the copied path, which auto-dismisses after a brief pause.
    function notifyCopied(path) {
        toaster.success(qsTr("Copied to clipboard"), { "description": path, "duration": 2000 })
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ==== Top bar ====
        Item {
            Layout.fillWidth: true
            implicitHeight: 52

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: win.compact ? 8 : 20
                anchors.rightMargin: 16
                spacing: 10

                // Hamburger button: only in the Components section + narrow screens, opens the sidebar drawer.
                IconButton {
                    visible: win.compact && win.section === "components"
                    iconName: "menu"
                    variant: IconButton.Ghost
                    onClicked: navDrawer.open()
                }
                // Text {
                //     text: qsTr("shadcn/ui")
                //     color: Theme.foreground
                //     font.pixelSize: 15
                //     font.weight: Font.DemiBold
                // }
                // Text {
                //     text: qsTr("QML")
                //     color: Theme.mutedForeground
                //     font.pixelSize: 13
                // }

                // Main navigation: Components / Charts / Create
                RowLayout {
                    //Layout.leftMargin: 14
                    spacing: 18
                    NavTab { text: qsTr("Components"); active: win.section === "components"; onClicked: win.section = "components" }
                    NavTab { text: qsTr("Charts"); active: win.section === "charts"; onClicked: win.section = "charts" }
                    NavTab { text: qsTr("Create"); active: win.section === "create"; onClicked: win.section = "create" }
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

        // ==== Section switch: Components / Charts / Create ====
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: win.section === "components" ? 0 : (win.section === "charts" ? 1 : 2)

            // ---- 0: Components (sidebar + content) ----
            RowLayout {
                spacing: 0

                // ==== Left navigation (inline on wide screens; collapsed on narrow, uses a drawer instead) ====
                DocsSidebar {
                    id: sidebar
                visible: !win.compact
                Layout.preferredWidth: win.compact ? 0 : 240
                Layout.fillHeight: true
                model: win.nav
                currentId: win.currentId
                onItemClicked: (item) => win.select(item)
            }

            // ==== Right content area: top toolbar + Preview (example cards) / API (embedded qdoc docs) ====
            ColumnLayout {
                id: contentArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                property bool showApi: false
                readonly property string apiHtml: win.apiFile(win.currentId)
                // Offer the API toggle only when docs have been generated (docsBaseUrl non-empty) and the component has a corresponding page.
                readonly property bool apiAvail: (typeof docsBaseUrl !== "undefined")
                                                 && docsBaseUrl !== "" && apiHtml !== ""
                onApiAvailChanged: if (!apiAvail) showApi = false
                // Return to Preview when switching components.
                Connections { target: win; function onCurrentIdChanged() { contentArea.showApi = false } }

                // ---- Top toolbar: left (API mode only) back/refresh/open externally; right Preview|API segment ----
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

                        // Preview | API segment
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
                    // Toolbar bottom separator line
                    Rectangle {
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                        height: 1
                        color: Theme.border
                    }
                }

                // ---- Preview: example cards ----
                ScrollView {
                    id: contentScroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: !contentArea.showApi
                    clip: true
                    // Content width locked to the viewport's available width → never produces horizontal scrolling; the page shrinks responsively with the window width.
                    contentWidth: availableWidth

                    Item {
                        width: contentScroll.availableWidth
                        implicitHeight: pageLoader.implicitHeight + 2 * pageLoader.y

                        Loader {
                            id: pageLoader
                            readonly property int pad: parent.width < 560 ? 16 : 40
                            x: pad
                            y: pad
                            // Fill the viewport's available width (no longer capped at 760), so cards grow as the window widens.
                            width: Math.max(0, parent.width - 2 * pad)
                            source: win.currentPage !== "" ? win.currentPage : "PagePlaceholder.qml"
                            // Pass title/description to the page scaffold; for pages that need to fill the viewport (e.g. the theme customizer's two columns),
                            // also pass the available viewport height so its inner two columns scroll individually rather than the whole page scrolling.
                            onLoaded: {
                                if (!item)
                                    return
                                if (item.hasOwnProperty("componentLabel"))
                                    item.componentLabel = win.currentLabel
                                if (item.hasOwnProperty("viewportHeight"))
                                    item.viewportHeight = Qt.binding(function () {
                                        return Math.max(360, contentScroll.availableHeight - 2 * pageLoader.pad)
                                    })
                            }
                        }
                    }
                }

                // ---- API: embedded qdoc docs (lazy-loaded, instantiated only when switching to API) ----
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

            // ---- 1: Charts (placeholder, not yet implemented) ----
            Item {
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text {
                        text: qsTr("Charts")
                        color: Theme.foreground
                        font.pixelSize: 24
                        font.weight: Font.DemiBold
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: qsTr("Coming soon.")
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textSm
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // ---- 2: Create (theme customizer, full width) ----
            Item {
                PageThemeCustomizer {
                    anchors.fill: parent
                    anchors.margins: 24
                    viewportHeight: height
                }
            }
        }
    }

    // ==== Narrow-screen sidebar drawer (opened by the hamburger button; auto-closes after selection) ====
    QC.Drawer {
        id: navDrawer
        edge: Qt.LeftEdge
        width: 260
        height: win.height
        // If the window widens past compact while the drawer is open, close it automatically.
        Connections { target: win; function onCompactChanged() { if (!win.compact) navDrawer.close() } }

        background: Rectangle { color: Theme.background }

        DocsSidebar {
            anchors.fill: parent
            model: win.nav
            currentId: win.currentId
            onItemClicked: (item) => { win.select(item); navDrawer.close() }
        }
    }

    // ==== Global Toast layer (covers the whole window, stacked at bottom-right) ====
    ToastArea {
        id: toaster
        anchors.fill: parent
        position: ToastArea.BottomEnd
        z: 1000
    }
}
