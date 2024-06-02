import gleam/result
import gleeunit
import gleeunit/should
import xmleam/xml_builder.{
  Opt, block_tag, end_xml, new, option_block_tag, option_content_tag, option_tag,
  tag,
}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn xml_builder_cdata_test() {
  xml_builder.new()
  |> xml_builder.cdata_tag("link", "<a href=\"https://example.com\"> link </a>")
  |> xml_builder.end_xml
  |> result.unwrap("ERROR")
  |> should.equal(
    "<link>\n<![CDATA[\n \t<a href=\"https://example.com\"> link </a>\n]]>\n</link>\n",
  )
}

///Test all of the functions
pub fn xml_builder_full_test() {
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
  |> result.unwrap("ERROR")
  |> should.equal(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss xmlns:itunes=\"http://www.itunes.com/dtds/podcast-1.0.dtd\">\n<channel>\n<title>Example RSS Feed</title>\n<description>this is a teaching example for xmleam</description>\n</channel>\n<item>\n<title>Example Item</title>\n</item>\n</rss>\n",
  )

  xml_builder.new_document()
  |> option_tag("link", [Opt("href", "https://example.com"), Opt("idk", "N/A")])
  |> option_content_tag("hello", [Opt("world", "Earth")], "AAAAAAA")
  |> end_xml()
  |> result.unwrap("ERROR")
  |> should.equal(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<link href=\"https://example.com\" idk=\"N/A\"/>\n<hello world=\"Earth\">AAAAAAA</hello>\n",
  )

  xml_builder.new()
  |> xml_builder.comment("This is a comment")
  |> end_xml()
  |> result.unwrap("ERROR")
  |> should.equal("<!-- This is a comment --> \n")

  xml_builder.new()
  |> xml_builder.block_comment({
    xml_builder.new()
    |> tag("hello", "world")
  })
  |> end_xml()
  |> result.unwrap("ERROR")
  |> should.equal("<!--\n<hello>world</hello>\n-->\n")
}
