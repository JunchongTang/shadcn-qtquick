# Component Review Progress

Tracks the per-component review sweep. For each component we do four things
(see the workflow): **A**udit (bugs / base-mira fidelity), **D**ocs (QDoc + English,
no Chinese), **T**ests (QuickTest), **F**idelity (compare to `reference/shadcn-ui/`).

Legend: ✅ done · 🔶 partial · ⬜ pending · — n/a

| # | Component | Files | A | D | T | F | Notes |
|---|---|---|---|---|---|---|---|
| 1 | Accordion | Accordion, AccordionItem | ⬜ | ⬜ | ⬜ | ⬜ | |
| 2 | Alert | Alert | ⬜ | ⬜ | ⬜ | ⬜ | |
| 3 | AlertDialog | AlertDialog | ⬜ | ⬜ | ⬜ | ⬜ | fixes #003/#006 already landed |
| 4 | AspectRatio | AspectRatio | ⬜ | ⬜ | ⬜ | ⬜ | |
| 5 | Attachment | Attachment(+8 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 6 | Avatar | Avatar | ⬜ | ⬜ | ⬜ | ⬜ | fix #007 landed |
| 7 | Badge | Badge | ⬜ | ⬜ | ⬜ | ⬜ | |
| 8 | Breadcrumb | Breadcrumb(+5 parts) | ⬜ | ⬜ | ⬜ | ⬜ | fix #008 landed |
| 9 | Bubble | Bubble(+3 parts) | ⬜ | ⬜ | ⬜ | ⬜ | fix #009 landed |
| 10 | Button | Button | ⬜ | ⬜ | ⬜ | ⬜ | enum-collision checked: safe |
| 11 | ButtonGroup | ButtonGroup(+2 parts) | ⬜ | ⬜ | ⬜ | ⬜ | fixes #010–#014 landed |
| 12 | Calendar | Calendar | ⬜ | ⬜ | ⬜ | ⬜ | fixes #015/#017 landed |
| 13 | Card | Card(+5 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 14 | Carousel | Carousel, CarouselItem | ⬜ | ⬜ | ⬜ | ⬜ | fix #018 landed |
| 15 | Chart | Chart, ChartLegend, ChartTooltip | ⬜ | ⬜ | ⬜ | ⬜ | |
| 16 | Checkbox | Checkbox | ⬜ | ⬜ | ⬜ | ⬜ | |
| 17 | Collapsible | Collapsible | ⬜ | ⬜ | ⬜ | ⬜ | |
| 18 | Combobox | Combobox, ComboboxChip | 🔶 | ⬜ | ✅ | ⬜ | tests exist; fix #020 landed |
| 19 | Command | Command | ⬜ | ⬜ | ⬜ | ⬜ | |
| 20 | ContextMenu | ContextMenu | ⬜ | ⬜ | ⬜ | ⬜ | fix #021 landed |
| 21 | DatePicker | DatePicker, DateRangePicker | ✅ | ✅ | ⬜ | 🔶 | #025; toggle needs real-machine check |
| 22 | Dialog | Dialog | ✅ | ✅ | ⬜ | 🔶 | #026; blur needs real-machine check |
| 23 | Drawer | Drawer | ✅ | ✅ | ⬜ | 🔶 | #027; examples aligned |
| 24 | Empty | Empty(+5 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 25 | Field | Field(+9 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 26 | FocusRing | FocusRing | ⬜ | ⬜ | — | ⬜ | internal util |
| 27 | Form | FormDescription, FormField, FormMessage | ⬜ | ⬜ | ⬜ | ⬜ | |
| 28 | HoverCard | HoverCard | ⬜ | ⬜ | ⬜ | ⬜ | |
| 29 | IconButton | IconButton | ⬜ | ⬜ | ⬜ | ⬜ | enum-collision checked: safe |
| 30 | Input | Input | ⬜ | ⬜ | ⬜ | ⬜ | |
| 31 | InputGroup | InputGroup(+5 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 32 | InputOtp | InputOtp, InputOtpSeparator, InputOtpSlot | ⬜ | ⬜ | ⬜ | ⬜ | |
| 33 | Item | ShadItem, Item*(9 parts) | ⬜ | ⬜ | ⬜ | ⬜ | enum-collision checked: safe |
| 34 | Kbd | Kbd, KbdGroup | ⬜ | ⬜ | ⬜ | ⬜ | |
| 35 | Label | Label | ⬜ | ⬜ | ⬜ | ⬜ | |
| 36 | Marker | Marker | ⬜ | ⬜ | ⬜ | ⬜ | |
| 37 | Menu | Menu(+5 parts) | ⬜ | ⬜ | ⬜ | ⬜ | fix #002 landed |
| 38 | Menubar | Menubar, MenubarMenu, MenubarTrigger | ⬜ | ⬜ | ⬜ | ⬜ | |
| 39 | Message | Message(+5 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 40 | MessageScroller | MessageScroller | ⬜ | ⬜ | ⬜ | ⬜ | |
| 41 | NativeSelect | NativeSelect | ⬜ | ⬜ | ⬜ | ⬜ | |
| 42 | NavigationMenu | NavigationMenu(+4 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 43 | Pagination | Pagination | ⬜ | ⬜ | ⬜ | ⬜ | |
| 44 | Popover | Popover | ⬜ | ⬜ | ⬜ | ⬜ | |
| 45 | Progress | Progress | ⬜ | ⬜ | ⬜ | ⬜ | |
| 46 | RadioGroup | RadioButton, RadioGroup | ⬜ | ⬜ | ⬜ | ⬜ | |
| 47 | RangeSlider | RangeSlider | ⬜ | ⬜ | ⬜ | ⬜ | |
| 48 | Resizable | Resizable | ⬜ | ⬜ | ⬜ | ⬜ | |
| 49 | RoundedImage | RoundedImage | ⬜ | ⬜ | — | ⬜ | internal util (#007) |
| 50 | ScrollArea | ScrollArea | ⬜ | ⬜ | ⬜ | ⬜ | |
| 51 | ScrollView | ScrollView | ⬜ | ⬜ | ⬜ | ⬜ | |
| 52 | Select | Select | ⬜ | ⬜ | ⬜ | ⬜ | fix #013 landed |
| 53 | Separator | Separator | ⬜ | ⬜ | ⬜ | ⬜ | |
| 54 | Sheet | Sheet | ⬜ | ⬜ | ⬜ | ⬜ | |
| 55 | Sidebar | Sidebar(+12 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |
| 56 | Skeleton | Skeleton | ⬜ | ⬜ | ⬜ | ⬜ | |
| 57 | Slider | Slider | ⬜ | ⬜ | ⬜ | ⬜ | |
| 58 | Spinner | Spinner | ⬜ | ⬜ | ⬜ | ⬜ | |
| 59 | Switch | Switch | ⬜ | ⬜ | ⬜ | ⬜ | |
| 60 | Tabs | Tabs, TabButton | ⬜ | ⬜ | ⬜ | ⬜ | fix #005 landed |
| 61 | Table | Table, TableColumn | ✅ | ✅ | ✅ | ✅ | #023/#024 |
| 62 | Textarea | Textarea | ⬜ | ⬜ | ⬜ | ⬜ | |
| 63 | Theme | Theme | ⬜ | ⬜ | — | — | singleton / design tokens |
| 64 | Toast | Toast, ToastArea | ⬜ | ⬜ | ⬜ | ⬜ | |
| 65 | Toggle | Toggle, ToggleGroup, ToggleGroupItem | ✅ | ✅ | ✅ | ✅ | #028 |
| 66 | Tooltip | Tooltip | ⬜ | ⬜ | ⬜ | ⬜ | |
| 67 | Typography | Typography*(13 parts) | ⬜ | ⬜ | ⬜ | ⬜ | |

## Batches (10 components each)

- **Batch 1**: 1–10 (Accordion … Button)
- **Batch 2**: 11–20 (ButtonGroup … ContextMenu)
- **Batch 3**: 21–30 (DatePicker … Input) — several already done this session
- **Batch 4**: 31–40 (InputGroup … MessageScroller)
- **Batch 5**: 41–50 (NativeSelect … ScrollArea)
- **Batch 6**: 51–60 (ScrollView … Tabs)
- **Batch 7**: 61–67 (Table … Typography) — several already done
