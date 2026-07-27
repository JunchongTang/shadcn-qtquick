// QuickTest entry point: scans and runs tst_*.qml under QUICK_TEST_SOURCE_DIR.
// Static QML modules (Shadcn / LucideIcons) auto-register via linking, so the QML side can import them directly.
#include <QtQuickTest/quicktest.h>

QUICK_TEST_MAIN(shadcn)
