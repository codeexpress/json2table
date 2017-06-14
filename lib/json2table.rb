# This module contains the entire source code needed to
# convert a JSON blob into a HTML Table.
#
# The gem is at http://rubygems.org/gems/json2table
# To install the gem, run command `gem install json2table`
# @author CodeExpress

require 'json'
require 'set'

module Json2table
  
  def self.get_html_table(json_str, options = {})
    html = ""
    begin
      if json_str.is_a?(Hash)
        hash = json_str
      else
        hash = JSON.parse(json_str)
      end
    rescue Exception => e
      puts "JSON2TABLE:: Input not a valid JSON, provide valid JSON object"
      puts e.message
      throw e
    end
    html = self.create_table(hash, options)
    return html
  end

  def self.create_table(hash, options)
    html = start_table_tag(options)
    if hash.is_a?(Array)
      html += "<tr><td>\n"
      #puts ">>>> #{process_array(hash, options)}"
      html += process_array(hash, options)
    else
    hash.each do |key, value|
       # key goes in a column and value in second column of the same row
       html += "<tr><th>#{to_human(key)}</th>\n"
       html += "<td>"
      
       if value.is_a?(Hash)
         # create a row with key as heading and body
         # as another table
         html += create_table(value, options)
       elsif value.is_a?(Array)
             html += process_array(value, options)
       else      # simple primitive data type of value (non hash, non array)
         html += "#{value}</td></tr>\n"
       end
     end
    end
    html += close_table_tag
    return html
  end

def self.process_array(arr, options)
    html = ""
        if arr[0].is_a?(Hash) # Array of hashes
          keys = similar_keys?(arr)
          if keys
            # if elements of this array are hashes with same keys,
            # display it as a top-down table
            html += create_vertical_table_from_array(arr, keys, options)
          else
            # non similar keys, create horizontal table
            arr.each do |h|
              html += create_table(h, options)
            end
          end
        else
          # array of a primitive data types eg. [1,2,3]
          # all values can be displayed in in cell
          html += "#{arr}</td></tr>\n"
        end
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
      html += "<th>#{to_human(key)}</th>\n"
    end
    html += "</tr>\n"
    array_of_hashes.each do |hash|
      html += "<tr>\n"
      keys.each do |key|
        if hash[key].is_a?(Hash) # another hash, create table out of it
          html += "<td>#{create_table(hash[key], options)}</td>\n"
        elsif hash[key].is_a?(Array)
          if hash[key][0].is_a?(Hash) # Array of hashes
            k = similar_keys?(hash[key])
            if k
              # if elements of this array are hashes with same keys,
              # display it as a top-down table
              html += create_vertical_table_from_array(value, k, options)
            else
              # non similar keys, create horizontal table
              hash[key].each do |h|
                html += create_table(h, options)
              end
            end
          end
        else
          html += "<td>#{hash[key]}</td>\n"
        end
      end
      html += "</tr>\n"
    end
    html += self.close_table_tag
  end
  def self.start_table_tag(options)
    "<table class='#{options[:table_class]}' 
            style='#{options[:table_style]}'
            #{options[:table_attributes]} >\n"
  end

  def self.close_table_tag
    "</table>\n"
  end
  
  # turns CamelCase and snake_case keys to human readable strings
  # Input:  this_isA_mixedCAse_line-string
  # Output: "This Is A Mixed C Ase Line String"
  def self.to_human(key)
    key.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').
      gsub(/([a-z\d])([A-Z])/,'\1 \2').
      tr("-", " ").tr("_", " ").
      split.map {|word| word.capitalize}.join(" ")
  end
end
