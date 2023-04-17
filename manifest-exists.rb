#!/usr/bin/env ruby

require 'FileUtils'

$manifest_is_valid = true

def check_file_is_valid(source_dir, filename)
  source_file = source_dir + filename

  unless File.file?(source_file)
    puts "! Missing: " + filename
    $manifest_is_valid = false
    return
  end

  if check_file_case_sensitive(source_dir, filename) == false
    puts "! Case: " + filename
    $manifest_is_valid = false
  end
end

def check_file_case_sensitive(source_dir, filename)
  filepath = File.dirname(filename)
  filename = filename.sub(filepath+'/', '')
  source_dir += filepath

  return Dir[File.join(source_dir, "*")].select {|f| File.basename(f) == filename}.any?
end

manifest = ARGV[0].nil? ? '' : ARGV[0]

unless File.file?(manifest)
  print "Missing " + manifest + " to read from\n"
  exit(1)
end

unless File.open(manifest).read().include? "basepath"
  print "No <basepath> lines to read from manifest\n"
  exit(1)
end

puts "Checking manifest files..."

source_dir = manifest.sub('manifest.php', '')
lines = File.readlines(manifest).grep /basepath/

lines.each do |line|
  filename = line.match(/'from' *=> *'<basepath>\/(custom\/[a-zA-Z0-9\/_\-.]+)'/)

  unless filename.nil?
    check_file_is_valid(source_dir, filename[1])
  end
end

if $manifest_is_valid
  puts "OK"
end

