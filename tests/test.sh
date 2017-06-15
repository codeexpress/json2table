#!/bin/bash

# This file converts all the sample json files into
# one single file => output.html
# This command should run without any errors and the
# generated JSON file 'should make sense'
#
# This is for the json2table to pass a quick smell-test (vision-test?)
# rather than rigrous tests

# blank out the output.html file
echo "" > output.html

for file in samples/sample?.json
do
    echo "Converting " $file ...
    echo "<h2 style='color:purple;'>Converting " $file "</h2><hr />" >> output.html
    cat $file | ruby ../example/example.rb >> output.html
done
