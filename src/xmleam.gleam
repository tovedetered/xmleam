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
    |> xml_builder.comment("Below this is a link example")
    |> option_tag("link", [
      Opt("href", "https://example.com"),
      Opt("idk", "N/A"),
    ])
    |> xml_builder.block_comment({
      {
        xml_builder.new()
        |> option_content_tag("hello", [Opt("world", "Earth")], "AAAAAAA")
      }
    })
    |> end_xml()
  }

  io.println(result.unwrap(document, "ERROR"))

  let document = {
    xml_builder.new()
    |> xml_builder.cdata_tag(
      "link",
      "<a href=\"https://example.com\"> link </a>",
    )
    |> xml_builder.end_xml
    |> result.unwrap("ERROR")
  }

  io.println(document)
}
