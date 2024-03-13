import gleam/io
import gleam/result
import xmleam/xml_builder.{
  Opt, block_tag, end_xml, new, option_block_tag, option_content_tag, option_tag,
  tag,
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
        })
        |> block_tag("item", {
          new()
          |> tag("title", "Example Item")
        })
      },
    )
    |> end_xml()
  }

  io.println(result.unwrap(document, "ERROR"))

  let document = {
    xml_builder.new_document()
    |> option_tag("link", [
      Opt("href", "https://example.com"),
      Opt("idk", "N/A"),
    ])
    |> option_content_tag("hello", [Opt("world", "Earth")], "AAAAAAA")
    |> end_xml()
  }

  io.println(result.unwrap(document, "ERROR"))
}
