#include <Cocoa/Cocoa.h>

int tools[] = {
    0x23, // p: Pen
    0x0E  // e: Eraser
};
int toolCount = 2;

int main() {
  NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
  int i = [d integerForKey:@"tool"];
  CGEventSourceRef src = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
  CGEventPost(kCGHIDEventTap, CGEventCreateKeyboardEvent(src, tools[i], true));
  CGEventPost(kCGHIDEventTap, CGEventCreateKeyboardEvent(src, tools[i], false));
  [d setInteger:i >= toolCount - 1 || i < 0 ? 0 : i + 1 forKey:@"tool"];
  usleep(5000);
  return 0;
}

// vim:ft=objc
