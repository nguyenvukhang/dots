use std::path::PathBuf;

fn main() {
    let src: String = std::env::args().skip(1).next().unwrap();
    let src: PathBuf = PathBuf::from(src);

    // let src_text =
    println!("{}", src);
}
