////Goals for this module:
//// 1. make xml like the string_builder
////    ie. xml_builder.new()
////        |> xml_builder.block_tag("name", {
////            xml_builder.new()
////            |> xml_builder.tag("hello", "world")
////            |> xml_builder.tag("maybe", "here")})
////        |> xml_builder.option_tag("link", Opt.("href", "https://example.com"))
//// To:
//// <?xml version="1.0" encoding="UTF-8" xml?>
//// <name>
////    <hello> world </hello>
//// </name>

import gleam/string_builder
import gleam/string
import gleam/result
import gleam/bool

pub type BuilderError {
  ContentsEmpty
  TagNameEmpty
  OptionsEmpty
  VersionEmpty
  EncodingEmpty
  TagPlacedBeforeNew
}

pub type XmlBuilder =
  Result(string_builder.StringBuilder, BuilderError)

/// this function starts the builder and 
/// this function assumes version 1.0 and encoding UTF-8 if you need specific verisons or encoding
/// use new_advanced_document(version, encoding)
pub fn new_document() -> XmlBuilder {
  string_builder.new()
  |> string_builder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
  |> Ok
}

/// this funcion starts the builder and 
/// allows you to put in your own version and encoding
pub fn new_advanced_document(version: String, encoding: String) -> XmlBuilder {
  let version_empty = string.is_empty(version)
  use <- bool.guard(when: version_empty, return: Error(VersionEmpty))
  let encoding_empty = string.is_empty(encoding)
  use <- bool.guard(when: encoding_empty, return: Error(EncodingEmpty))

  string_builder.new()
  |> string_builder.append("<?xml version=\"")
  |> string_builder.append(version)
  |> string_builder.append("\" encoding=\"")
  |> string_builder.append(encoding)
  |> string_builder.append("\"?> \n")
  |> Ok
}

/// this function starts the blocks inside of tags
pub fn new() -> XmlBuilder {
  string_builder.new()
  |> Ok
}

/// this is a basic tag that takes in a label and contents and a 
/// document in the form of an XmlBuilder
/// this is intended to be used in a pipe chain
/// ie. new_document()
///     |> tag("hello", "world")
/// Throws an error if anything is left blank
pub fn tag(label: String, contents: String, document: XmlBuilder) -> XmlBuilder {
  let label_empty = string.is_empty(label)
  use <- bool.guard(when: label_empty, return: Error(TagNameEmpty))
  let contents_empty = string.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))
  let documents_empty =
    string_builder.is_empty(result.unwrap(document, string_builder.new()))
  use <- bool.guard(when: documents_empty, return: Error(TagPlacedBeforeNew))

  string_builder.new()
  |> string_builder.append("<")
  |> string_builder.append(label)
  |> string_builder.append("> ")
  |> string_builder.append(contents)
  |> string_builder.append(" </")
  |> string_builder.append(label)
  |> string_builder.append("> \n")
  |> string_builder.append_builder(to: result.unwrap(
    document,
    string_builder.new(),
  ))
  |> Ok
}
