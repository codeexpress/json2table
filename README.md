# Introduction

`json2table` is a ruby library and executable to convert valid JSON objects to
HTML tables. `json2table` is also available as a rubygem for quick installation.

# Get json2table

You can get `json2table` by install gem or cloning git repo.

## Download gem

Download gem from [rubygems](https://rubygems.org/gems/json2table/) as:
```
$ gem install json2table
```

## Clone git repository

Clone this repository as:
```
$ git clone https://github.com/codeexpress/json2table
```
# Usage

## As a standalone program

If you've installed the gem, `json2table` is available as a cli command, which can be used as follwing:

```
$ cat some.json | json2table # outputs table
```

## In your ruby code as library

Refer to the `example/example.rb` file for sample implementation

```ruby
require 'json2table' # if you've installed the gem

#require 'path/to/lib/json2table.rb'# if you've git clone'd the repo

table_options = {
  table_style: "border: 1px solid black; max-width: 600px;",
  table_class: "table table-striped table-hover table-condensed table-bordered",
  table_attributes: "border=1"
  }
  json = STDIN.read

  json2table =  Json2table::get_html_table(json, table_options)
  puts json2table
```

Invoke `example.rb` as:
```bash
$ cd example
$ cat input.json | ruby example.rb > output.html
```
