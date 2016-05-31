require 'optparse'
require 'tempfile'

Version = "0.1.0"
options = {}

# parse options
OptionParser.new do |opts|
  opts.banner = """
Description:  Script to remove extra translations from an Android project.
              Starting with the default value string resource file as a reference,
              the script will iterate through each string resource file and remove the extra translation lines.
              If no resource_dir_path argument is specified then the script will attempt to run in the current directory.

Usage: android-extra-translation-remover.rb [OPTIONS]"""
  opts.separator ""
  opts.separator "Options"
  opts.separator ""
  opts.on("-r","--resource_dir_path PATH", "path to Android project\'s resource directory") do |resource_dir_path|
    options[:resource_dir_path] = resource_dir_path
  end
  opts.on_tail("-h", "--help", "help") do
    puts opts
    exit
  end
  opts.on_tail("--version", "version") do
    puts Version
    exit
  end
end.parse!

# set resource_dir_path from option or as current directory
resource_dir_path = options.key?(:resource_dir_path) ? options[:resource_dir_path] : Dir.pwd
# construct path to default string resource file
default_string_resource_file = File.join(resource_dir_path, "values", "strings.xml")
# get list of value directories
value_dirs = []
if (File.exists? default_string_resource_file)
  value_dirs = Dir.entries(resource_dir_path).select {|entry| File.directory? File.join(resource_dir_path, entry) and entry.start_with? "values-" and File.exists? File.join(resource_dir_path, entry, "strings.xml")}
else
  puts "No default string resource file found at %s" %[default_string_resource_file]
end
# get list of translations
default_translations = []
File.open(default_string_resource_file).each_line do |line|
  if line =~ /<string name=/
    default_translations << /<string name=['"](.*)['"]>/.match(line)[1]
  end
end
# iterate through non-default string resource files and remove extra translations
num_translations_removed_total = 0
removed_translations_print_outs = []
value_dirs.each do |value_dir|
  num_translations_removed = 0
  file_path = File.join(resource_dir_path, value_dir, "strings.xml")
  temp_file = Tempfile.new('strings.xml')
  File.open(file_path).each_line do |line|
    if line =~ /<string name=/ and !default_translations.include? /<string name=['"](.*)['"]>/.match(line)[1]
      print_out = "Deleting extra translation: %s" %[line]
      num_translations_removed += 1
      num_translations_removed_total += 1
    else
      temp_file.write(line)
    end
  end
  temp_file.rewind
  temp_file.read
  temp_file.close
  FileUtils.mv temp_file, file_path
  temp_file.unlink
  if num_translations_removed > 0
    print_out = "\nRemoved %s translations from %s" %[num_translations_removed, file_path]
    removed_translations_print_outs << print_out
  end
end
puts removed_translations_print_outs
if num_translations_removed_total > 0
  puts "\nSuccessfully removed %s extra translations!" %[num_translations_removed_total]
else
  puts "\nNo extra translations to remove."
end
