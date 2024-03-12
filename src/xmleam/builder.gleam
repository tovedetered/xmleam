import gleam/string
import gleam/string_builder
import gleam/bool
import gleam/list

pub type XmlError {
  ContentsEmpty
  TagNameEmpty
  OptionsEmpty
  VersionEmpty
  EncodingEmpty
}

pub type Option {
  Opt(label: String, value: String)
}

///This is a basic tag, ie. name and the contents
/// Ex. builder.basic_tag("pubDate", "12 Mar 2024") to
/// <pubDate> 12 Mar 2024 <pubDate> \n
/// basic_tag(tag_name, contents)
pub fn basic_tag(
  tag_name: String,
  contents: List(String),
) -> Result(String, XmlError) {
  //Input pubDate, ____date -> <pubDate>_____date</pubDate>
  let tag_name_empty = string.is_empty(tag_name)
  use <- bool.guard(when: tag_name_empty, return: Error(TagNameEmpty))
  let contents_empty = list.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))

  let string_contents = string.concat(contents)

  string_builder.new()
  |> string_builder.append("<")
  |> string_builder.append(tag_name)
  |> string_builder.append("> ")
  |> string_builder.append(string_contents)
  |> string_builder.append(" </")
  |> string_builder.append(tag_name)
  |> string_builder.append("> \n")
  |> string_builder.to_string()
  |> Ok
}

///This is a tag with options and content
/// Ex. opts_cont_tag("enclosure", [opts("url", "https://example.com")], 
/// "IDK why you would use this")
/// -> 
/// <enclosure url="https://example.com"> IDK why you would use this </enclosure>
pub fn opts_cont_tag(
  tag_name: String,
  options: List(Option),
  contents: List(String),
) -> Result(String, XmlError) {
  let tag_name_empty = string.is_empty(tag_name)
  use <- bool.guard(when: tag_name_empty, return: Error(TagNameEmpty))
  let contents_empty = list.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))
  let options_empty = list.is_empty(options)
  use <- bool.guard(when: options_empty, return: Error(OptionsEmpty))

  let string_contents = string.concat(contents)

  string_builder.new()
  |> string_builder.append("<")
  |> string_builder.append(tag_name)
  |> string_builder.append(string_options(options))
  |> string_builder.append("> \n ")
  |> string_builder.append(string_contents)
  |> string_builder.append(" </")
  |> string_builder.append(tag_name)
  |> string_builder.append("> \n")
  |> string_builder.to_string
  |> Ok
}

pub fn opts_tag(
  tag_name: String,
  options: List(Option),
) -> Result(String, XmlError) {
  let tag_name_empty = string.is_empty(tag_name)
  use <- bool.guard(when: tag_name_empty, return: Error(TagNameEmpty))
  let contents_empty = list.is_empty(options)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))

  string_builder.new()
  |> string_builder.append("<")
  |> string_builder.append(tag_name)
  |> string_builder.append(string_options(options))
  |> string_builder.append(" /> \n")
  |> string_builder.to_string()
  |> Ok()
}

///This is the header tag REQUIRED by all valid XML documents
/// Usage: xml(version (1.0), encoding (UTF-8), 
/// document: List(String) -> [basic_tag(...), basic_tag(...)])
pub fn xml(
  version: String,
  encoding: String,
  document_parts: List(String),
) -> Result(String, XmlError) {
  let version_empty = string.is_empty(version)
  use <- bool.guard(when: version_empty, return: Error(VersionEmpty))
  let encoding_empty = string.is_empty(encoding)
  use <- bool.guard(when: encoding_empty, return: Error(EncodingEmpty))

  let document = string.concat(document_parts)

  string_builder.new()
  |> string_builder.append("<?xml version=\"")
  |> string_builder.append(version)
  |> string_builder.append("\" encoding=\"")
  |> string_builder.append(encoding)
  |> string_builder.append("\"?> \n")
  |> string_builder.append(document)
  |> string_builder.to_string
  |> Ok
}

fn string_options(options: List(Option)) -> String {
  let str_option_list = list.map(options, option_to_string)
  list.fold(str_option_list, "", string.append)
}

fn option_to_string(option: Option) -> String {
  string.concat([" ", option.label, "=\"", option.value, "\""])
}
