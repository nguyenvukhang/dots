from datetime import datetime

now = datetime.today()
w0 = datetime(2024, 1, 8)
now = datetime(2024, 1, 8)

        # (24, 1, 15, "W1"),

i = int((now - w0).days / 7)

print('diff', i)
print("now", now)
print("w5", w0)
