import gleam/io
import xmleam/builder

pub fn main() {
  let tag = builder.basic_tag("pubDate", "Tue Mar 12")
  let complex_tag =
    builder.opts_cont_tag(
      "enclosure",
      [builder.Opt("url", "https://example.com")],
      "hello",
    )
  io.debug(complex_tag)
  io.debug(tag)
}
