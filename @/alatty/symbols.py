font = "JuliaMono"

with open("symbols.txt", "r") as f:
    text = f.read()

codepoints = []

for line in text.splitlines():
    codepoint, description = line.split(";", maxsplit=1)
    description = description.strip().removeprefix("Math").strip().lower()
    codepoint = "-".join("U+" + x.strip() for x in codepoint.split(".."))

    codepoint = codepoint.replace("U+2113", "U+2112")

    if "arrow" in description:
        continue
    if codepoint.startswith("U+00"):
        continue

    codepoints.append(codepoint)

codepoints.append("U+03C7")

output_lines = [f"symbol_map {codepoint} {font}\n" for codepoint in codepoints]
with open("math_symbols.conf", "w") as f:
    f.writelines(output_lines)
