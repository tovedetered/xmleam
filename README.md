# xmleam

[![Package Version](https://img.shields.io/hexpm/v/xmleam)](https://hex.pm/packages/xmleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/xmleam/)

```sh
gleam add xmleam
```
```gleam
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
  io.print(result.unwrap(document, "ENCODING Error"))
}

//Result
<?xml version="1.0" encoding="UTF-8"?> 
<Hello> World </Hello> 
<link href="https://example.com" />

```

Further documentation can be found at <https://hexdocs.pm/xmleam>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
