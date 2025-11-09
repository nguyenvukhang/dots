use std::collections::HashSet;
use std::io::Write;
use std::path::Path;
use std::{env, fs};

macro_rules! color {
    ($(($name:ident, $x:expr)),+) => {
        $( pub const $name : &str = $x;)+
        pub const LIST: &[&str] = &[ $($x,)+ ];
    };
}

/// The source color palette.
#[allow(unused)]
mod color_src {
    color!(
        (BG0, "#282828"),
        (BG1, "#3c3836"),
        (BG2, "#504945"),
        (BG3, "#665c54"),
        (BG4, "#7c6f64"),
        (FG0, "#e5d2aa"),
        (FG1, "#e5d2aa"),
        (FG2, "#d5c4a1"),
        (FG3, "#bdae93"),
        (FG4, "#a89984"),
        (RED, "#ea6962"),
        (GREEN, "#a9b665"),
        (YELLOW, "#d8a657"),
        (BLUE, "#7daea3"),
        (PURPLE, "#d3869b"),
        (AQUA, "#89b48c"),
        (ORANGE, "#e78a4e"),
        (GRAY, "#928374")
    );
}

#[allow(unused)]
/// The destination color palette.
mod color_dst {
    const BG0: &str = "#282828";
    const BG1: &str = "#3c3836";
    const BG2: &str = "#504945";
    const BG3: &str = "#665c54";
    const BG4: &str = "#7c6f64";
    const FG0: &str = "#e5d2aa";
    const FG1: &str = "#e5d2aa";
    const FG2: &str = "#d5c4a1";
    const FG3: &str = "#bdae93";
    const FG4: &str = "#a89984";
    const RED: &str = "#ea6962";
    const GREEN: &str = "#a9b665";
    const YELLOW: &str = "#d8a657";
    const BLUE: &str = "#7daea3";
    const PURPLE: &str = "#d3869b";
    const AQUA: &str = "#89b48c";
    const ORANGE: &str = "#e78a4e";
    const GRAY: &str = "#928374";
}

fn get_hex_code(v: &str) -> Option<&str> {
    if v.len() < 7 {
        return None;
    }
    let u = v.strip_prefix('#')?;
    for c in u.chars().take(6) {
        match c {
            '0'..='9' | 'a'..='z' => continue,
            _ => return None,
        }
    }
    Some(&v[0..7])
}

fn main() {
    let Some(first_arg) = env::args().skip(1).next() else {
        return println!("Use first arg as the source");
    };
    let Ok(mut src) = fs::read_to_string(&first_arg) else {
        return println!("Something went wrong trying to read the source file");
    };

    let mut hex_codes = HashSet::new();
    for mut line in src.lines() {
        loop {
            if let Some(hex) = get_hex_code(line) {
                hex_codes.insert(hex);
                line = line.strip_prefix(hex).unwrap();
            }
            if line.is_empty() {
                break;
            }
            line = &line[1..];
        }
    }

    // let src_text =
    println!("{:?}", hex_codes);

    let l = color_src::LIST;
    for hex in hex_codes {
        assert!(l.contains(&hex), "{hex}");
    }

    const N: usize = color_src::LIST.len();
    for i in 0..N {
        let a = color_src::LIST[i];
        let b = color_src::LIST[i];
        if a == b {
            continue;
        }
        let next = src.replace(a, b);
        let _ = core::mem::replace(&mut src, next);
    }

    let outfile = Path::new(&first_arg);
    let file_stem = outfile.file_stem().unwrap().to_str().unwrap().to_string() + "_generated";
    let outfile = outfile.with_file_name(file_stem).with_extension("vim");

    let mut f = fs::File::create(outfile).unwrap();
    write!(f, "{src}").unwrap();
}
