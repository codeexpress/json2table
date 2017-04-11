require './json2html'

json = STDIN.read
json2html = Json2html::get_html_table(json)
puts json2html

