import gleam/io
import gleam/result
import xmleam/builder.{Opt}

pub fn main() {
  let document = {
    builder.opts_cont_tag(
      "?xml",
      [Opt("version", "1.0"), Opt("encoding", "UTF-8")],
      { result.unwrap(builder.basic_tag("hello", "world"), "Encoding Error") },
    )
  }
  io.debug(document)
}
