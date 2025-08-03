import os
import json
import re
from pathlib import Path

def load_json(file_path):
    with open(file_path, encoding="utf-8") as f:
        return json.load(f)

def resolve_reference(ref, palette):
    match = re.match(r"\{colors\.([a-zA-Z0-9]+)\.([0-9]+)\}", ref)
    if match:
        color_family, shade = match.groups()
        return palette["colors"][color_family][shade]["value"]
    return ref

def hex_to_components(hex_str):
    hex_str = hex_str.lstrip("#")
    r, g, b, a = None, None, None, "1.000"

    if len(hex_str) == 6:
        r, g, b = hex_str[0:2], hex_str[2:4], hex_str[4:6]
    elif len(hex_str) == 8:
        r, g, b, alpha_hex = hex_str[0:2], hex_str[2:4], hex_str[4:6], hex_str[6:8]
        a = f"{int(alpha_hex, 16) / 255:.3f}"

    return {
        "red": f"0x{r.upper()}",
        "green": f"0x{g.upper()}",
        "blue": f"0x{b.upper()}",
        "alpha": a
    }

def flatten_tokens(tokens, prefix=""):
    flat = {}
    for key, val in tokens.items():
        new_prefix = f"{prefix}.{key}" if prefix else key
        if isinstance(val, dict) and "value" in val:
            flat[new_prefix] = val["value"]
        elif isinstance(val, dict):
            flat.update(flatten_tokens(val, new_prefix))
    return flat

def build_contents_json(universal_hex, light_hex, dark_hex):
    def entry(appearance, hex_val):
        return {
            "appearances": [{"appearance": "luminosity", "value": appearance}],
            "color": {
                "color-space": "srgb",
                "components": hex_to_components(hex_val)
            },
            "idiom": "universal"
        }

    return {
        "colors": [
            {
                "color": {
                    "color-space": "srgb",
                    "components": hex_to_components(universal_hex)
                },
                "idiom": "universal"
            },
            entry("light", light_hex),
            entry("dark", dark_hex)
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }

def write_json(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

def main():
    base_dir = Path.cwd()
    xcassets_dir = base_dir / "Assets.xcassets"

    palette = load_json("colorPalette.json")
    tokens_light = flatten_tokens(load_json("tokensLightTheme.json")["tokens"])
    tokens_dark = flatten_tokens(load_json("tokensDarkTheme.json")["tokens"])

    all_keys = set(tokens_light.keys()) | set(tokens_dark.keys())

    for token_path in sorted(all_keys):
        light_value = tokens_light.get(token_path)
        dark_value = tokens_dark.get(token_path)

        if light_value:
            light_hex = resolve_reference(light_value, palette)
        else:
            light_hex = dark_hex = resolve_reference(dark_value, palette)

        if dark_value:
            dark_hex = resolve_reference(dark_value, palette)
        else:
            dark_hex = light_hex

        universal_hex = light_hex

        *dirs, color_name = token_path.split(".")
        out_dir = xcassets_dir.joinpath(*dirs, f"{color_name}.colorset")
        out_path = out_dir / "Contents.json"

        contents = build_contents_json(universal_hex, light_hex, dark_hex)
        write_json(out_path, contents)

        print(f"✅ {out_path.relative_to(base_dir)}")

if __name__ == "__main__":
    main()
