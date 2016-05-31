require 'optparse'

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
string_resource_files = []
if (File.exists? default_string_resource_file)
  string_resource_files = Dir.entries(resource_dir_path).select {|entry| File.directory? File.join(resource_dir_path, entry) and entry.start_with? "values-" and File.exists? File.join(resource_dir_path, entry, "strings.xml")}
else
  puts "No default string resource file found at %s" %[default_string_resource_file]
end
