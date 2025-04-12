#!/usr/bin/env ruby

require 'date'
require 'fileutils'
require 'yaml'

class SugarManifest
  def boilerplate(current_time = nil)
    current_time ||= DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
    config = self.get_config

    line = "$manifest = [\n"
    line << "    'acceptable_sugar_versions' => ['regex_matches' => ['[131425].*']],\n"
    line << "    'acceptable_sugar_flavors' => ['PRO', 'ENT', 'ULT'],\n"
    line << "    'author' => '" +config['author_name']+ "',\n"
    line << "    'description' => 'Short description on what package does',\n"
    line << "    'icon' => '',\n"
    line << "    'is_uninstallable' => true,\n"
    line << "    'key' => 'unique-package-id',\n"
    line << "    'name' => 'Package Name',\n"
    line << "    'published_date' => '"+current_time+"',\n"
    line << "    'type' => 'module',\n"
    line << "    'readme' => '',\n"
    line << "    'remove_tables' => '',\n"
    line << "    'version' => '0.1.0',\n"
    line << "];\n"
  end

  def get_config
    unless File.exist?(__dir__  + "/config.yaml")
      FileUtils.cp(__dir__  + "/config.example.yaml", __dir__  + "/config.yaml")
    end

    return YAML.load_file(__dir__  + "/config.yaml")
  end

  def install_defs(copy_defs = '')
    if copy_defs.empty?
      copy_defs << "        [\n"
      copy_defs << "            'from' => '<basepath>',\n"
      copy_defs << "            'to' => '',\n"
      copy_defs << "        ],\n"
    end

    line = "$installdefs = [\n"
    line << "    'id' => 'unique-package-id',\n"
    line << "    'copy' => [\n"
    line << copy_defs
    line << "    ]\n"
    line << "];\n"
  end

  def get_filenames(file_list)
    if file_list.empty?
      return ""
    end

    workfiles = []
    lines = File.readlines(file_list)

    lines.each do |line|
      workfiles.push(line.chomp!)
    end
  end

  def generate_copy_lines(workfiles)
    copy_defs = ""

    workfiles.each do |workfile|
      workfile.strip!
      copy_defs << "        [\n"
      copy_defs << "            'from' => '<basepath>/" +workfile+ "',\n"
      copy_defs << "            'to' => '" +workfile+ "',\n"
      copy_defs << "        ],\n"
    end

    copy_defs << ""
  end

  def rebuild_installdefs(manifest_file, copydef_lines)
    install_defs_line = 0

    File.open(manifest_file).each_line.with_index(0) do |line, index|
       install_defs_line = index if line['$installdefs']
    end

    if install_defs_line > 0
      existing_manifest = ""
      File.open(manifest_file).each_line.with_index(0) do |line, index|
        if index < install_defs_line
          existing_manifest << line
        end
      end

      existing_manifest << copydef_lines
      File.write(manifest_file, existing_manifest)
    end
  end
end

if __FILE__ == $0
  manifest_file = "manifest.php"
  copy_defs = ""
  manifester = SugarManifest.new

  unless ARGV.empty?
    workfiles = manifester.get_filenames(ARGV[0])
    copy_defs << manifester.generate_copy_lines(workfiles)
  end

  if File.file?(manifest_file)
    copydef_lines = manifester.install_defs(copy_defs)
    manifester.rebuild_installdefs(manifest_file, copydef_lines)
  else
    content = "<?php\n\n"
    content << manifester.boilerplate
    content << "\n"
    content << manifester.install_defs(copy_defs)

    File.write(manifest_file, content)
  end
end
