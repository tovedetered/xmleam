import gleeunit
import gleeunit/should
import xmleam/builder
import gleam/result

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn xml_test() {
  builder.xml("1.0", "UTF-8", [""])
  |> result.unwrap("Frick")
  |> should.equal("<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n")
}
