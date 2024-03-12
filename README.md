# xmleam

[![Package Version](https://img.shields.io/hexpm/v/xmleam)](https://hex.pm/packages/xmleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/xmleam/)

```sh
gleam add xmleam
```
```gleam
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
```

Further documentation can be found at <https://hexdocs.pm/xmleam>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
