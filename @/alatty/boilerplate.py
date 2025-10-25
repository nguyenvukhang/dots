# Map CMD to ALT by brute force.
for x in map(chr, range(97, 123)):
    print(f"map cmd+shift+{x} send_text all \\x1b{x}")
    print(f"map cmd+{x} send_text all \\x1b{x}")
