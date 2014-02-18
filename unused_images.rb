# The MIT License (MIT)
# 
# Copyright (c) 2014 Adam Tootle
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


require 'optparse'

$stdout.sync = true

#
# define/detect options
#
options = {
  :retina => 'false'
}

using_help = false

OptionParser.new do |parser|
  parser.banner = "Usage: find.rb PATH [OPTIONS]"
  parser.separator  ""
  parser.separator  "Example"
  parser.separator  "     ruby find.rb ~/Apps/my-app"
  parser.separator  ""
  parser.separator  "Options"

  parser.on("--retina=true","search for @2x images. defaults to false") do |retina|
    options[:retina] = retina
  end

  parser.on("-h","--help","help") do
    puts parser
    using_help = true
  end
end.parse!

exit if using_help

#
# set our path option
#
if !ARGV[0].nil? && ARGV[0].length > 0
  options[:path] = ARGV[0]
else
  options[:path] = './'
end

options[:path] = options[:path].sub(' ',  '\ ');

#
# find our image files and return paths
#

if options[:retina] == 'true'
  images_string = `find #{options[:path]} -name "*.png" -o -name "*.jpg"`
else
  images_string = `find #{options[:path]} -name "*.png" -not -name "*@2x*" -o -name "*.jpg" -not -name "*@2x*"`
end

images_array = images_string.split("\n")

#
# find any references to the filenames from above
#

puts "#{images_array.count} images found"
print "searching"
files_array = []
images_array.map do |image|
  print "."
  filename = image.split('/').last
  results = `ack #{filename} #{options[:path]}`
  files_array << filename if results.length == 0
end

if files_array.length > 0
  puts "\n\n"
  puts "the following images are not used:\n\n"
  
  files_array.each do |file|
    puts file
  end
else
  puts "\n\n"
  puts "it looks like all images are being used"
end