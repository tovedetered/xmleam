import gleam/io
import gleam/result
import xmleam/xml_builder.{
  Opt, block_tag, end, end_xml, new, option_block_tag, tag,
}

pub fn main() {
  let document = {
    xml_builder.new_document()
    |> option_block_tag(
      "rss",
      [Opt("xmlns:itunes", "http://www.itunes.com/dtds/podcast-1.0.dtd")],
      {
        new()
        |> block_tag("channel", {
          new()
          |> tag("title", "Example RSS Feed")
          |> tag("description", "this is a teaching example for xmleam")
          |> end()
        })
        |> block_tag("item", {
          new()
          |> tag("title", "Example Item")
          |> end()
        })
        |> end()
      },
    )
    |> end_xml()
  }

  io.debug(result.unwrap(document, "ERROR"))
}
