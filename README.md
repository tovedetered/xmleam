# xmleam

[![Package Version](https://img.shields.io/hexpm/v/xmleam)](https://hex.pm/packages/xmleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/xmleam/)


```sh
gleam add xmleam
```

To add to a Gleam Project  ^

```gleam
import gleam/io
import gleam/result
import xmleam/xml_builder.{
  Opt, block_tag, end, end_xml, new, option_block_tag, option_content_tag,
  option_tag, tag,
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
        |> option_content_tag("hello", [Opt("world", "Earth")], "North America")
      }
    })
    |> end_xml()
  }

  io.println(result.unwrap(document, "ERROR"))
}


//Result
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"> 
<channel> 
<title> Example RSS Feed </title> 
<description> this is a teaching example for xmleam </description> 
</channel> 
<item> 
<title> Example Item </title> 
</item> 
</rss> 

<?xml version="1.0" encoding="UTF-8"?>
<!-- Below this is a link example --> 
<link href="https://example.com" idk="N/A" />
<!-- 
<hello world="Earth"> North America </hello> 
-->  
```

Further documentation can be found at <https://hexdocs.pm/xmleam>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
