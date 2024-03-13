import gleam/io
import xmleam/xml_builder.{block_tag, new, tag}

pub fn main() {
  let document = {
    xml_builder.new_document()
    |> block_tag(
      "hello",
      new()
        |> tag("world", "Earth")
        |> xml_builder.end,
    )
    |> xml_builder.end_xml()
  }

  io.debug(document)
}
