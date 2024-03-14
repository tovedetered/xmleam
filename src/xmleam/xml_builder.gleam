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

import gleam/string_builder.{append, append_builder}
import gleam/string
import gleam/result
import gleam/bool
import gleam/list

pub type BuilderError {
  ContentsEmpty
  LabelEmpty
  OptionsEmpty
  VersionEmpty
  EncodingEmpty
  TagPlacedBeforeNew
  InnerEmpty
  EmptyDocument

  NOTAPPLICABLE
}

pub type Option {
  Opt(label: String, value: String)
}

pub type XmlBuilder =
  Result(string_builder.StringBuilder, BuilderError)

/// starts the builder and assumes version 1.0 and encoding UTF-8, 
/// if you need specific verisons or encoding
/// use new_advanced_document(version, encoding)
pub fn new_document() -> XmlBuilder {
  string_builder.new()
  |> string_builder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
  |> Ok
}

/// starts the builder and 
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

/// starts the blocks inside of tags because of the requirement 
/// of document and not having be optional
pub fn new() -> XmlBuilder {
  string_builder.new()
  |> Ok
}

/// Basic tag that takes in a label and contents and a 
/// document in the form of an XmlBuilder
/// this is intended to be used in a pipe chain
/// ie. new_document() 
///     |> tag("hello", "world")
/// Throws an error if anything is left blank
pub fn tag(document: XmlBuilder, label: String, contents: String) -> XmlBuilder {
  let label_empty = string.is_empty(label)
  use <- bool.guard(when: label_empty, return: Error(LabelEmpty))
  let contents_empty = string.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))

  case result.is_error(document) {
    True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

    False ->
      string_builder.new()
      |> append("<")
      |> append(label)
      |> append("> ")
      |> append(contents)
      |> append(" </")
      |> append(label)
      |> append("> \n")
      |> append_builder(
        to: result.unwrap(document, string_builder.new()),
        suffix: _,
      )
      |> Ok
  }
}

/// Tag with options and content
/// ie. <hello world="hi"> ?? <hello> 
pub fn option_content_tag(
  document: XmlBuilder,
  label: String,
  options: List(Option),
  contents: String,
) {
  let label_empty = string.is_empty(label)
  use <- bool.guard(when: label_empty, return: Error(LabelEmpty))
  let contents_empty = string.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))
  let options_empty = list.is_empty(options)
  use <- bool.guard(when: options_empty, return: Error(OptionsEmpty))

  case result.is_error(document) {
    True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

    False ->
      string_builder.new()
      |> append("<")
      |> append(label)
      |> append_builder(string_options(options))
      |> append("> ")
      |> append(contents)
      |> append(" </")
      |> append(label)
      |> append("> \n")
      |> append_builder(
        to: result.unwrap(document, string_builder.new()),
        suffix: _,
      )
      |> Ok
  }
}

///Tag with options that self-closes 
/// ie. <link href="https://example.com" />
pub fn option_tag(document: XmlBuilder, label: String, options: List(Option)) {
  let label_empty = string.is_empty(label)
  use <- bool.guard(when: label_empty, return: Error(LabelEmpty))
  let options_empty = list.is_empty(options)
  use <- bool.guard(when: options_empty, return: Error(OptionsEmpty))

  case result.is_error(document) {
    True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

    False ->
      string_builder.new()
      |> append("<")
      |> append(label)
      |> append_builder(string_options(options))
      |> append(" />\n")
      |> append_builder(
        to: result.unwrap(document, string_builder.new()),
        suffix: _,
      )
      |> Ok
  }
}

fn string_options(options: List(Option)) {
  list.map(options, option_to_string)
  |> string_builder.concat
}

fn option_to_string(option: Option) {
  string_builder.from_strings([" ", option.label, "=\"", option.value, "\""])
}

/// Starts a block which is a tag with other tags inside of it
/// ie. <owner>
///         <email>example@example.com</email>
///     </owner>
/// 
/// Usage: |>block_tag("owner", {
///     new()
///     |> tag("email", "example@example.com")
/// })
pub fn block_tag(document: XmlBuilder, label: String, inner: XmlBuilder) {
  let label_empty = string.is_empty(label)
  use <- bool.guard(when: label_empty, return: Error(LabelEmpty))
  let inner_empty =
    string_builder.is_empty(result.unwrap(inner, string_builder.new()))
  use <- bool.guard(when: inner_empty, return: Error(InnerEmpty))

  case result.is_error(document) {
    True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

    False ->
      case result.is_error(inner) {
        True -> Error(result.unwrap_error(inner, NOTAPPLICABLE))

        False ->
          string_builder.new()
          |> append("<")
          |> append(label)
          |> append("> \n")
          |> append_builder(result.unwrap(inner, string_builder.new()))
          |> append("</")
          |> append(label)
          |> append("> \n")
          |> append_builder(
            to: result.unwrap(document, string_builder.new()),
            suffix: _,
          )
          |> Ok
      }
  }
}

/// block tag that also has options
pub fn option_block_tag(
  document: XmlBuilder,
  label: String,
  options: List(Option),
  inner: XmlBuilder,
) {
  let label_empty = string.is_empty(label)
  use <- bool.guard(when: label_empty, return: Error(LabelEmpty))
  let inner_empty =
    string_builder.is_empty(result.unwrap(inner, string_builder.new()))
  use <- bool.guard(when: inner_empty, return: Error(InnerEmpty))
  let options_empty = list.is_empty(options)
  use <- bool.guard(when: options_empty, return: Error(OptionsEmpty))

  case result.is_error(document) {
    True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

    False ->
      case result.is_error(inner) {
        True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

        False ->
          string_builder.new()
          |> append("<")
          |> append(label)
          |> append_builder(string_options(options))
          |> append("> \n")
          |> append_builder(result.unwrap(inner, string_builder.new()))
          |> append(" </")
          |> append(label)
          |> append("> \n")
          |> append_builder(
            to: result.unwrap(document, string_builder.new()),
            suffix: _,
          )
          |> Ok
      }
  }
}

/// Ends the XML document
/// takes in the XML Document and outputs
/// a Result(String, BuilderError)
pub fn end_xml(document: XmlBuilder) -> Result(String, BuilderError) {
  case result.is_error(document) {
    True -> Error(result.unwrap_error(document, NOTAPPLICABLE))

    False ->
      case
        string_builder.is_empty(result.unwrap(document, string_builder.new()))
      {
        True -> Error(EmptyDocument)

        False ->
          result.unwrap(document, string_builder.new())
          |> string_builder.to_string
          |> Ok
      }
  }
}
