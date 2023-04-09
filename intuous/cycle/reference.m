#include <CoreGraphics/CoreGraphics.h>
#include <Foundation/Foundation.h>

// {{{
enum KeyCode {
  // https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066

  // Layout-independent Keys
  // eg.These key codes are always the same key on all layouts.
  returnKey = 0x24,
  tab = 0x30,
  space = 0x31,
  delete = 0x33,
  escape = 0x35,
  command = 0x37,
  shift = 0x38,
  capsLock = 0x39,
  option = 0x3A,
  control = 0x3B,
  rightShift = 0x3C,
  rightOption = 0x3D,
  rightControl = 0x3E,
  leftArrow = 0x7B,
  rightArrow = 0x7C,
  downArrow = 0x7D,
  upArrow = 0x7E,
  volumeUp = 0x48,
  volumeDown = 0x49,
  mute = 0x4A,
  help = 0x72,
  home = 0x73,
  pageUp = 0x74,
  forwardDelete = 0x75,
  end = 0x77,
  pageDown = 0x79,
  function = 0x3F,
  f1 = 0x7A,
  f2 = 0x78,
  f4 = 0x76,
  f5 = 0x60,
  f6 = 0x61,
  f7 = 0x62,
  f3 = 0x63,
  f8 = 0x64,
  f9 = 0x65,
  f10 = 0x6D,
  f11 = 0x67,
  f12 = 0x6F,
  f13 = 0x69,
  f14 = 0x6B,
  f15 = 0x71,
  f16 = 0x6A,
  f17 = 0x40,
  f18 = 0x4F,
  f19 = 0x50,
  f20 = 0x5A,

  // US-ANSI Keyboard Positions
  // eg. These key codes are for the physical key (in any keyboard layout)
  // at the location of the named key in the US-ANSI layout.
  a = 0x00,
  b = 0x0B,
  c = 0x08,
  d = 0x02,
  e = 0x0E,
  f = 0x03,
  g = 0x05,
  h = 0x04,
  i = 0x22,
  j = 0x26,
  k = 0x28,
  l = 0x25,
  m = 0x2E,
  n = 0x2D,
  o = 0x1F,
  p = 0x23,
  q = 0x0C,
  r = 0x0F,
  s = 0x01,
  t = 0x11,
  u = 0x20,
  v = 0x09,
  w = 0x0D,
  x = 0x07,
  y = 0x10,
  z = 0x06,

  zero = 0x1D,
  one = 0x12,
  two = 0x13,
  three = 0x14,
  four = 0x15,
  five = 0x17,
  six = 0x16,
  seven = 0x1A,
  eight = 0x1C,
  nine = 0x19,

  equals = 0x18,
  minus = 0x1B,
  semicolon = 0x29,
  apostrophe = 0x27,
  comma = 0x2B,
  period = 0x2F,
  forwardSlash = 0x2C,
  backslash = 0x2A,
  grave = 0x32,
  leftBracket = 0x21,
  rightBracket = 0x1E,

  keypadDecimal = 0x41,
  keypadMultiply = 0x43,
  keypadPlus = 0x45,
  keypadClear = 0x47,
  keypadDivide = 0x4B,
  keypadEnter = 0x4C,
  keypadMinus = 0x4E,
  keypadEquals = 0x51,
  keypad0 = 0x52,
  keypad1 = 0x53,
  keypad2 = 0x54,
  keypad3 = 0x55,
  keypad4 = 0x56,
  keypad5 = 0x57,
  keypad6 = 0x58,
  keypad7 = 0x59,
  keypad8 = 0x5B,
  keypad9 = 0x5C,
};
// }}}

int tools[] = {
    p, // Pen
    e  // Eraser
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
