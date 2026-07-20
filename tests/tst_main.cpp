// QuickTest 入口:扫描 QUICK_TEST_SOURCE_DIR 下的 tst_*.qml 并运行。
// 静态 QML 模块(Shadcn / LucideIcons)通过链接自动注册,QML 侧可直接 import。
#include <QtQuickTest/quicktest.h>

QUICK_TEST_MAIN(shadcn)
