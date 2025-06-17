#!/usr/bin/env ruby

require 'FileUtils'
require 'open3'

$manifest_is_valid = true
$file_count = 0

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

  if check_valid_php(source_dir, filename) == false
    puts "! Invalid PHP: " + filename
    $manifest_is_valid = false
  end
end

def check_manifest_is_valid()
  if check_valid_php('', 'manifest.php') == false
    puts "! Invalid Manifest"
    $manifest_is_valid = false
  end
end

def check_file_case_sensitive(source_dir, filename)
  filepath = File.dirname(filename)
  filename = filename.sub(filepath+'/', '')
  source_dir += filepath

  return Dir[File.join(source_dir, "*")].select {|f| File.basename(f) == filename}.any?
end

def check_valid_php(source_dir, filename)
  filepath = File.dirname(filename)
  filename = filename.sub(filepath+'/', '')
  source_dir += filepath
  stdout_str, stderr_str, status = Open3.capture3('php -l '+source_dir+"/"+filename)

  unless status.to_s.include? "exit 0"
    puts "⚠️  "+stderr_str
    $manifest_is_valid = false
  end
end

def get_package_details(manifest)
  regex_package_name = /'name' => +'([\w\d -.']+)'/
  regex_version = /'version' => +'([\w\d .']+)'/
  package_name_line = File.readlines(manifest).grep(regex_package_name)

  package_name = package_name_line[0].match(regex_package_name)

  if package_name.nil?
    return ''
  else
    version_line = File.readlines(manifest).grep(regex_version)
    version = version_line[0].match(regex_version)

    return '📦 ' + package_name[1] + ': version ' + version[1]
  end
end

manifest = ARGV[0].nil? ? '' : ARGV[0]

puts get_package_details(manifest)

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
    $file_count+=1
  end
end

check_manifest_is_valid

if $manifest_is_valid
  puts "OK"
end

puts "Checked "+$file_count.to_s+" files"
