import gleam/string
import gleam/string_builder
import gleam/bool
import gleam/list

pub type XmlError {
  ContentsEmpty
  TagNameEmpty
  OptionsEmpty
}

pub type Option {
  Opt(label: String, value: String)
}

///This is a basic tag, ie. name and the contents
/// Ex. builder.basic_tag("pubDate", "12 Mar 2024") to
/// <pubDate> 12 Mar 2024 <pubDate> \n
/// basic_tag(tag_name, contents)
pub fn basic_tag(tag_name: String, contents: String) -> Result(String, XmlError) {
  //Input pubDate, ____date -> <pubDate>_____date</pubDate>
  let tag_name_empty = string.is_empty(tag_name)
  use <- bool.guard(when: tag_name_empty, return: Error(TagNameEmpty))
  let contents_empty = string.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))

  string_builder.new()
  |> string_builder.append("<")
  |> string_builder.append(tag_name)
  |> string_builder.append("> ")
  |> string_builder.append(contents)
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
  contents: String,
) -> Result(String, XmlError) {
  let tag_name_empty = string.is_empty(tag_name)
  use <- bool.guard(when: tag_name_empty, return: Error(TagNameEmpty))
  let contents_empty = string.is_empty(contents)
  use <- bool.guard(when: contents_empty, return: Error(ContentsEmpty))
  let options_empty = list.is_empty(options)
  use <- bool.guard(when: options_empty, return: Error(OptionsEmpty))

  string_builder.new()
  |> string_builder.append("<")
  |> string_builder.append(tag_name)
  |> string_builder.append(string_options(options))
  |> string_builder.append("> ")
  |> string_builder.append(contents)
  |> string_builder.append(" </")
  |> string_builder.append(tag_name)
  |> string_builder.append("> \n")
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
