# Component Review Progress

Tracks the per-component review sweep. For each component we do four things
(see the workflow): **A**udit (bugs / base-mira fidelity), **D**ocs (QDoc + English,
no Chinese), **T**ests (QuickTest), **F**idelity (compare to `reference/shadcn-ui/`).

Legend: ✅ done · 🔶 partial · ⬜ pending · — n/a

| # | Component | Files | A | D | T | F | Notes |
|---|---|---|---|---|---|---|---|
| 1 | Accordion | Accordion, AccordionItem | ✅ | ✅ | ✅ | 🔶 | flagged P2: no keyboard focus/ring, no title wrap |
| 2 | Alert | Alert | ✅ | ✅ | ✅ | 🔶 | flagged P2: action slot inline vs absolute |
| 3 | AlertDialog | AlertDialog | ✅ | ✅ | ✅ | ✅ | fixed P2 duplicate `accepted()` signal; #003/#006 intact |
| 4 | AspectRatio | AspectRatio | ✅ | ✅ | ✅ | ✅ | fixed P2 divide-by-zero on ratio≤0 |
| 5 | Attachment | Attachment(+8 parts) | ✅ | ✅ | ✅ | 🔶 | fixed P3 no-op ternary; padding approx flagged |
| 6 | Avatar | Avatar | ✅ | ✅ | ✅ | 🔶 | fixed P2 fallback font + P3 weight/ring; mix-blend approx |
| 7 | Badge | Badge | ✅ | ✅ | ✅ | ✅ | fixed 2×P3 dark-mode fills |
| 8 | Breadcrumb | Breadcrumb(+5 parts) | ✅ | ✅ | ✅ | ✅ | relaxed line-height fix; #008 intact |
| 9 | Bubble | Bubble(+3 parts) | ✅ | ✅ | ✅ | ✅ | fixed P2 #029 (reactions Top/Bottom inherited-enum collision); #009 intact |
| 10 | Button | Button | ✅ | ✅ | ✅ | 🔶 | verified vs style-mira; dark-mode color-mix approx flagged |
| 11 | ButtonGroup | ButtonGroup(+2 parts) | ✅ | ✅ | ✅ | 🔶 | no bugs; flagged Grid items-stretch/flex-1 limits |
| 12 | Calendar | Calendar | ✅ | ✅ | ✅ | ✅ | no bugs; #015/#017 intact |
| 13 | Card | Card(+5 parts) | ✅ | ✅ | ✅ | 🔶 | 2×P3 (title font); flagged per-child padding, CardAction unmodeled |
| 14 | Carousel | Carousel, CarouselItem | ✅ | ✅ | ✅ | 🔶 | fixed P2 nav focusPolicy; embla canScrollNext approx flagged |
| 15 | Chart | Chart, ChartLegend, ChartTooltip | ✅ | ✅ | ✅ | 🔶 | no bugs; Recharts-math simplifications flagged |
| 16 | Checkbox | Checkbox | ✅ | ✅ | ✅ | ✅ | fixed P2 label-less sizing + 2×P3 dark/focus |
| 17 | Collapsible | Collapsible | ✅ | ✅ | ✅ | ✅ | no bugs |
| 18 | Combobox | Combobox, ComboboxChip | ✅ | ✅ | ✅ | 🔶 | fixed P2 up-arrow off-by-one; #020 intact; autoHighlight flagged |
| 19 | Command | Command | ✅ | ✅ | ✅ | 🔶 | fixed P2 Enter-key bubbling; check-indicator flagged |
| 20 | ContextMenu | ContextMenu | ✅ | ✅ | ✅ | 🔶 | fixed P2 handler leak; touch long-press flagged; #021 intact |
| 21 | DatePicker | DatePicker, DateRangePicker | ✅ | ✅ | ✅ | 🔶 | #025; tests added; toggle needs real-machine check |
| 22 | Dialog | Dialog | ✅ | ✅ | ✅ | 🔶 | #026; tests added; blur needs real-machine check |
| 23 | Drawer | Drawer | ✅ | ✅ | ✅ | 🔶 | #027; tests added |
| 24 | Empty | Empty(+5 parts) | ✅ | ✅ | ✅ | 🔶 | no bugs; rich-text link styling unmodeled |
| 25 | Field | Field(+9 parts) | ✅ | ✅ | ✅ | 🔶 | no bugs; responsive/vertical-rhythm nuances flagged |
| 26 | FocusRing | FocusRing | ✅ | ✅ | ✅ | ✅ | fixed P3 square-target radius consistency |
| 27 | Form | FormDescription, FormField, FormMessage | ✅ | ✅ | ✅ | ✅ | 1×P3 text-left align |
| 28 | HoverCard | HoverCard | ✅ | ✅ | ✅ | ✅ | ✅ #029 fixed (Side→*Edge, Align.Center→Middle); +alignOffset |
| 29 | IconButton | IconButton | ✅ | ✅ | ✅ | 🔶 | no bugs; intentional Ghost default noted |
| 30 | Input | Input | ✅ | ✅ | ✅ | ✅ | fixed 2×P2 (disabled opacity, border→input token) + 3×P3 dark/ring |
| 31 | InputGroup | InputGroup(+5 parts) | ✅ | ✅ | ✅ | 🔶 | no P0/P1; flagged kbd edge-pull, group-disabled dimming |
| 32 | InputOtp | InputOtp, InputOtpSeparator, InputOtpSlot | ✅ | ✅ | ✅ | 🔶 | 2×P2 (divider/separator token+color) + dark variants |
| 33 | Item | ShadItem, Item*(9 parts) | ✅ | ✅ | ✅ | 🔶 | no bugs; enum-safe; image-variant child + focus-ring flagged |
| 34 | Kbd | Kbd, KbdGroup | ✅ | ✅ | ✅ | 🔶 | P3 rounded-xs 2px; text-only limitation flagged |
| 35 | Label | Label | ✅ | ✅ | ✅ | ✅ | no bugs |
| 36 | Marker | Marker | ✅ | ✅ | ✅ | 🔶 | P2 stacked sizing + P3 shimmer; shimmer-sweep approx flagged |
| 37 | Menu | Menu(+5 parts) | ✅ | ✅ | ✅ | 🔶 | P2 disabled-highlight + inset API; #002/#021 intact; radio-exclusivity real-machine |
| 38 | Menubar | Menubar, MenubarMenu, MenubarTrigger | ✅ | ✅ | ✅ | 🔶 | 2×P3 (unused import, trigger align) |
| 39 | Message | Message(+5 parts) | ✅ | ✅ | ✅ | 🔶 | no bugs; header self-end / ghost padding flagged |
| 40 | MessageScroller | MessageScroller | ✅ | ✅ | ✅ | 🔶 | P3 jump-button flicker; advanced anchoring omitted |
| 41 | NativeSelect | NativeSelect | ✅ | ✅ | ✅ | 🔶 | P3 dark invalid-border; enum-safe |
| 42 | NavigationMenu | NavigationMenu(+4 parts) | ✅ | ✅ | ✅ | 🔶 | P2 trigger h-9; focus-ring flagged |
| 43 | Pagination | Pagination | ✅ | ✅ | ✅ | 🔶 | no bugs; DOTS verified; RTL flagged |
| 44 | Popover | Popover | ✅ | ✅ | ✅ | 🔶 | no bugs; Align enum collision-safe (Popup) |
| 45 | Progress | Progress | ✅ | ✅ | ✅ | ✅ | P2 range support + P3 div0/indeterminate |
| 46 | RadioGroup | RadioButton, RadioGroup | ✅ | ✅ | ✅ | ✅ | 3×P2 (border order/focus/label-less) + dark |
| 47 | RangeSlider | RangeSlider | ✅ | ✅ | ✅ | ✅ | P1 collapsed default range + P2 focus ring |
| 48 | Resizable | Resizable | ✅ | ✅ | ✅ | 🔶 | no bugs; enum-safe (Qt.Horizontal/Vertical) |
| 49 | RoundedImage | RoundedImage | ✅ | ✅ | ✅ | ✅ | no bugs; layer+mask verified |
| 50 | ScrollArea | ScrollArea | ✅ | ✅ | ✅ | 🔶 | no bugs; baked border/rect-clip flagged |
| 51 | ScrollView | ScrollView | ✅ | ✅ | ✅ | 🔶 | P3 stale comment; clip/overlap parity flagged |
| 52 | Select | Select | ✅ | ✅ | ✅ | 🔶 | 3×P2 (border/chevron/size scale); #013 intact |
| 53 | Separator | Separator | ✅ | ✅ | ✅ | ✅ | no bugs; enum-safe |
| 54 | Sheet | Sheet | ✅ | ✅ | ✅ | ✅ | P2 #029 Side enum collision (→*Edge) + P2 body px-6 |
| 55 | Sidebar | Sidebar(+12 parts) | ✅ | ✅ | ✅ | 🔶 | P2 trigger size icon-sm; focus-ring flagged |
| 56 | Skeleton | Skeleton | ✅ | ✅ | ✅ | ✅ | 2×P2 pulse opacity/duration + P3 bezier |
| 57 | Slider | Slider | ✅ | ✅ | ✅ | ✅ | no bugs (RangeSlider's don't apply) |
| 58 | Spinner | Spinner | ✅ | ✅ | ✅ | 🔶 | P3 spin 1s; a11y-role flagged |
| 59 | Switch | Switch | ✅ | ✅ | ✅ | ✅ | 2×P2 thumb slide + dark-mode |
| 60 | Tabs | Tabs, TabButton | ✅ | ✅ | ✅ | 🔶 | P2 inactive label color; #005 intact |
| 61 | Table | Table, TableColumn | ✅ | ✅ | ✅ | ✅ | #023/#024 |
| 62 | Textarea | Textarea | ✅ | ✅ | ✅ | 🔶 | 2×P1 (border token, disabled opacity) + dark/focus |
| 63 | Theme | Theme | ✅ | ✅ | ✅ | 🔶 | tokens verified; amber palette unverifiable vs ref |
| 64 | Toast | Toast, ToastArea | ✅ | ✅ | ✅ | ✅ | P1 #029 Position enum (→Start/End); QDoc + tests |
| 65 | Toggle | Toggle, ToggleGroup, ToggleGroupItem | ✅ | ✅ | ✅ | ✅ | #028 |
| 66 | Tooltip | Tooltip | ✅ | ✅ | ✅ | ✅ | P1 #029 Side enum (→*Edge) + P2 added arrow; fixed SidebarMenuButton consumer |
| 67 | Typography | Typography*(13 parts) | ✅ | ✅ | ✅ | 🔶 | no bugs; table border-collapse flagged |

## Batches (10 components each)

- **Batch 1**: 1–10 (Accordion … Button)
- **Batch 2**: 11–20 (ButtonGroup … ContextMenu)
- **Batch 3**: 21–30 (DatePicker … Input) — several already done this session
- **Batch 4**: 31–40 (InputGroup … MessageScroller)
- **Batch 5**: 41–50 (NativeSelect … ScrollArea)
- **Batch 6**: 51–60 (ScrollView … Tabs)
- **Batch 7**: 61–67 (Table … Typography) — several already done
