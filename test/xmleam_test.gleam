import gleeunit
import gleeunit/should
import xmleam/xml_builder.{
  Opt, block_tag, end, end_xml, new, option_block_tag, tag,
}
import gleam/result

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
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
  |> result.unwrap("ERROR")
  |> should.equal(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss xmlns:itunes=\"http://www.itunes.com/dtds/podcast-1.0.dtd\"> \n<channel> \n<title> Example RSS Feed </title> \n<description> this is a teaching example for xmleam </description> \n</channel> \n<item> \n<title> Example Item </title> \n</item> \n </rss> \n",
  )
}
