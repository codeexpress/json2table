require '../lib/json2table'


table_options = {
  table_style: "border: 1px solid black; max-width: 600px;",
  table_class:
    "table table-striped table-hover table-condensed table-bordered",
  table_attributes: "border=1"
}

json = STDIN.read
json2table =
  Json2table::get_html_table(json, table_options)
puts json2table

