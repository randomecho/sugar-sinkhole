#!/usr/bin/env ruby

require 'FileUtils'

manifest = 'manifest.php'

def package_file(filename, source_dir = "../../../")
  source_file = source_dir + filename

  if File.file?(source_file)
    destination = File.dirname(filename)
    FileUtils.mkdir_p(destination)
    File.write(filename, File.read(source_file))

    puts '+ ' + filename
  else
    puts "! Cannot find: " + source_file
  end
end

unless File.file?(manifest)
  print "Missing " + manifest + " to read from\n"
  exit(1)
end

unless File.open(manifest).read().include? "basepath"
  print "No <basepath> lines to read from manifest\n"
  exit(1)
end

source_dir = ARGV[0].nil? ? '' ARGV[0]
lines = File.readlines(manifest).grep /basepath/

lines.each do |line|
  filename = line.match(/'from' => '<basepath>\/(custom\/[a-zA-Z0-9\/_\-.]+)'/)
  package_file(filename[1], source_dir)
end
