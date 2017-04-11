# This module contains the entire source code needed to
# convert a JSON blob into a HTML Table.
#
# The gem is at http://rubygems.org/gems/json2html
# To install the gem, run command `gem install json2html`
# @author CodeExpress

require 'json'
require 'set'

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
            html += create_vertical_table_from_array(value, keys, options)
          else
            # non similar keys, create horizontal table
            value.each do |h|
              html += self.create_table(h, options)
            end
          end
        else
          # array of a primitive data types eg. [1,2,3]
          # all values can be displayed in in cell
          html += "#{value}</td></tr>\n"
        end
      else      # simple primitive data type of value (non hash, non array)
        html += "#{value}</td></tr>\n"
      end
    end
    html += self.close_table_tag
    return html
  end

  # This method checks if all the individual array items
  # are hashes with similar keys.
  def self.similar_keys?(arr)
    previous_keys = Set.new
    current_keys   = Set.new
    arr.each do |hash|
      # every item of the array should be a hash, if not return false
      return nil if not  hash.is_a?(Hash)
      current_keys = hash.keys.to_set
      if previous_keys.empty?
        previous_keys = current_keys # happens on first iteration
      else
        # if different keys in two distinct array elements(hashes), return false 
        return nil if not (previous_keys^current_keys).empty?
        previous_keys = current_keys
      end
    end
    return arr[0].keys # all array elements were hash with same keys
  end

  # creates a vertical table of following form for the array of hashes like this:
  #        ---------------------
  #       | key1 | key2 | key3  |
  #        ---------------------
  #       | val1 | val2 | val3  |
  #       | val4 | val5 | val6  |
  #       | val9 | val8 | val7  |
  #        ---------------------
  def self.create_vertical_table_from_array(array_of_hashes, keys, options)
    html = start_table_tag(options)
    html += "<tr>\n"
    keys.each do |key|
      html += "<th>#{key}</th>\n"
    end
    html += "</tr>\n"
    array_of_hashes.each do |hash|
      html += "<tr>\n"
      keys.each do |key|
        html += "<td>#{hash[key]}</td>\n"
      end
      html += "</tr>\n"
    end
    html += self.close_table_tag
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
end
