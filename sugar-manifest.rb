#!/usr/bin/env ruby

require 'date'

def boilerplate
  d = DateTime.now

  line = "$manifest = [\n"
  line << "    'acceptable_sugar_versions' => ['regex_matches' => ['8.*']],\n"
  line << "    'acceptable_sugar_flavors' => ['PRO', 'ENT', 'ULT'],\n"
  line << "    'author' => $author,\n"
  line << "    'description' => $description,\n"
  line << "    'icon' => '',\n"
  line << "    'is_uninstallable' => true,\n"
  line << "    'key' => $key,\n"
  line << "    'name' => $package_name,\n"
  line << "    'published_date' => '"+d.strftime("%Y-%m-%d %H:%M:%S")+"',\n"
  line << "    'type' => 'module',\n"
  line << "    'readme' => '',\n"
  line << "    'remove_tables' => '',\n"
  line << "    'version' => $version,\n"
  line << "];\n"
end

def install_defs(copy_defs)
  if copy_defs.empty?
    copy_defs << "        [\n"
    copy_defs << "            'from' => '<basepath>',\n"
    copy_defs << "            'to' => '',\n"
    copy_defs << "        ],\n"
  end

  line = "$installdefs = [\n"
  line << "    'id' => strtolower(preg_replace('/([^a-zA-Z0-9])/', '-', $key.'_'.$package_name)),\n"
  line << "    'copy' => [\n"
  line << copy_defs
  line << "    ]\n"
  line << "];\n"
end

def get_filenames(file_list)
  workfiles = []
  lines = File.readlines(file_list)

  lines.each do |line|
    workfiles.push(line.chomp!)
  end
end

def generate_copy_lines(workfiles)
  copy_defs = ""

  workfiles.each do |workfile|
    copy_defs << "        [\n"
    copy_defs << "            'from' => '<basepath>/" +workfile+ "',\n"
    copy_defs << "            'to' => '" +workfile+ "',\n"
    copy_defs << "        ],\n"
  end

  copy_defs << ""
end

def summary
  line = "$author = 'Soon Van';\n"
  line << "$description = '';\n"
  line << "$key = 'SV-';\n"
  line << "$package_name = '';\n"
  line << "$version = 0.1;\n"
  line << "\n"
end

if __FILE__ == $0
  copy_defs = ""

  unless ARGV.empty?
    workfiles = get_filenames(ARGV[0])
    copy_defs << generate_copy_lines(workfiles)
  end

  content = "<?php\n\n"
  content << summary
  content << boilerplate
  content << "\n"
  content << install_defs(copy_defs)

  File.write('manifest.php', content)
end
