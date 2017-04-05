# This module contains the entire source code needed to
# convert a JSON blob into a HTML Table.
#
# The gem is at http://rubygems.org/gems/json2html
# To install the gem, run command `gem install json2html`
# @author CodeExpress

require 'json'

module Json2html
  
  def self.get_html_table(json_str, options = {})
    html = ""
    begin
      hash = JSON.parse(json_str)
    rescue Exception => e
      puts "JSON2HTML:: Input not a valid JSON, provide valid JSON object"
      puts e.message
      throw e
    end

    html = self.create_table(hash, options)
    
    return html
  end

  def self.create_table(hash, options)
    html = start_table_tag(options)
    hash.each do |key, value|

      # key goes in a column and value in second column of the same row
      html += "<tr><th>#{key}</th>\n"
      html += "<td>"
      
      if value.is_a?(Hash)
        # create a row with key as heading and body
        # as another table
        html += self.create_table(value, options)
      elsif value.is_a?(Array)
        if value[1].is_a?(Hash) # Array of hashes
          keys = similar_keys?(value)
          if keys
            # if elements of this array are hashes with same keys,
            # display it as a top-down table
            html += create_vertical_table_from_array(value, keys)
          else
            # non similar keys, create horizontal table
            value.each do |h|
              html += self.create_table(h, options)
            end
          end
        else
          # array if primitive data types, all values can be
          # displayed in in cell
          html += "<tr><th>#{key}</th>\n"
          html += "<td>"
          html += value
          html += "</td></tr>"
        end
      else      # simple primitive data type of value (non hash, non array)
        html += "<tr><th>#{key}</th><td>#{value}</td></tr>"
      end
      html += "</td></tr>" # close the value column and the row
    end
    html += self.close_table_tag
    return html
  end

  def self.start_table_tag(options)
    if options[:style] == "bootstrap"
      css_class = ""
    elsif not options[:table_class].nil?
      css_class = options[:table_class]
    end
    "<table class='#{css_class}' border=1>\n"
  end

  def self.close_table_tag
    "</table>\n"
  end

  def self.start_row_tag
    "<tr>\n"
  end

  def self.close_row_tag
    "</tr>\n"
  end

  def self.start_cell_tag
    "<td>\n"
  end

  def self.close_cell_tag
    "</td>\n"
  end

end
