import gleam/io
import gleam/result.{unwrap}
import xmleam/builder.{Opt, basic_tag, opts_tag}

pub fn main() {
  let document = {
    builder.xml("1.0", "UTF-8", [
      unwrap(basic_tag("Hello", ["World"]), "ENCODING ERROR"),
      unwrap(
        opts_tag("link", [Opt("href", "https://example.com")]),
        "ENCODING ERROR",
      ),
    ])
  }
  io.debug(result.unwrap(document, "ENCODING Error"))
}
