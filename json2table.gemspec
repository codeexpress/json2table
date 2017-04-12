Gem::Specification.new do |s|
  s.name          = 'json2table'
  s.version       = '1.0.2'
  s.date          = '2017-04-12'
  s.summary       = "Converts JSON to HTML tables"
  s.description   =
    "This gem provides functionality to convert a JSON object into HTML
  table. It can handle nested JSONs. Table class, styles and
  attributes can be provided."
    s.authors     = ["Code Express"]
    s.email       = 'code.expres@gmail.com'
    s.files       = ['lib/json2table.rb'] + Dir['examples/*']
    s.homepage    = 'https://github.com/codeexpress/json2table'
    s.license     = 'MIT'
end
