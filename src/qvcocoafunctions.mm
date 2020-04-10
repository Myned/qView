#include "qvcocoafunctions.h"

#import <Cocoa/cocoa.h>


QVCocoaFunctions::QVCocoaFunctions()
{

}

void QVCocoaFunctions::showMenu(QMenu *menu, const QPoint point, QWindow *window)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSMenu *nativeMenu = menu->toNSMenu();
    NSView *view = reinterpret_cast<NSView*>(window->winId());
    NSPoint transposedPoint = QPoint(point.x(), static_cast<int>(view.frame.size.height)-point.y()).toCGPoint();
    NSGraphicsContext *graphicsContext = [NSGraphicsContext currentContext];
    NSEvent *event = [NSEvent mouseEventWithType:NSEventTypeRightMouseDown location:transposedPoint modifierFlags:NULL
            timestamp:0 windowNumber:view.window.windowNumber context:graphicsContext eventNumber:0 clickCount:0 pressure:1];
    [NSMenu popUpContextMenu:nativeMenu withEvent:event forView:view];

    [pool release];
}

void QVCocoaFunctions::changeTitlebarMode(const VibrancyMode vibrancyMode, QWindow *window)
{
    NSView *view = reinterpret_cast<NSView*>(window->winId());
    NSWindow *nativeWin = view.window;
    switch (vibrancyMode) {
    case VibrancyMode::none:
    {
        [nativeWin setTitlebarAppearsTransparent:false];
        [nativeWin setStyleMask:view.window.styleMask];
        break;
    }
    case VibrancyMode::buttonsOnly:
    {
        [nativeWin setTitlebarAppearsTransparent:true];
        [nativeWin setStyleMask:view.window.styleMask | NSWindowStyleMaskFullSizeContentView];
        [nativeWin setTitleVisibility:NSWindowTitleHidden];
        break;
    }
    case VibrancyMode::vibrant:
    {
        [nativeWin setStyleMask:view.window.styleMask | NSWindowStyleMaskFullSizeContentView];
        break;
    }
    }
}