require 'optparse'

Version = "0.1.0"
options = {}
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

p options
p ARGV
p options[:resource_dir_path]
