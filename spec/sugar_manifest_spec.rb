require 'pp'
require 'fakefs/safe'
require_relative '../sugar-manifest'

describe SugarManifest do
  before do
    @manifester = SugarManifest.new
  end

  describe ".boilerplate" do
    it "creates boilerplate block" do
      expect(@manifester.boilerplate('2018-10-10')).to eq("$manifest = [
    'acceptable_sugar_versions' => ['regex_matches' => ['8.*']],
    'acceptable_sugar_flavors' => ['PRO', 'ENT', 'ULT'],
    'author' => $author,
    'description' => $description,
    'icon' => '',
    'is_uninstallable' => true,
    'key' => $key,
    'name' => $package_name,
    'published_date' => '2018-10-10',
    'type' => 'module',
    'readme' => '',
    'remove_tables' => '',
    'version' => $version,
];
")
    end
  end

  describe ".summary" do
    it "creates summary block" do
      expect(@manifester.summary).to eq("$author = 'Soon Van';
$description = '';
$key = 'SV-';
$package_name = '';
$version = 0.1;

")
    end
  end

  describe ".install_defs" do
    describe "given no lines" do
      it "creates placeholder copydef block" do
        expect(@manifester.install_defs).to eq("$installdefs = [
    'id' => strtolower(preg_replace('/([^a-zA-Z0-9])/', '-', $key.'_'.$package_name)),
    'copy' => [
        [
            'from' => '<basepath>',
            'to' => '',
        ],
    ]
];
")
      end
    end

    describe "given list of files" do
      it "creates copydef block with those files" do
        file_list = "list-of-filenames-as-prepared-by-generate_copy_lines"

        expect(@manifester.install_defs(file_list)).to eq("$installdefs = [
    'id' => strtolower(preg_replace('/([^a-zA-Z0-9])/', '-', $key.'_'.$package_name)),
    'copy' => [
list-of-filenames-as-prepared-by-generate_copy_lines    ]
];
")
      end
    end
  end

  describe ".generate_copy_lines" do
    describe "given empty array of filenames" do
      it "creates empty string" do
        expect(@manifester.generate_copy_lines([])).to eq("")
      end
    end

    describe "given array of files" do
      it "creates copydef block with those files" do
        file_list = ["path/to/tofu", "money-in-the-banana-stand"]

        expect(@manifester.generate_copy_lines(file_list)).to eq("        [
            'from' => '<basepath>/path/to/tofu',
            'to' => 'path/to/tofu',
        ],
        [
            'from' => '<basepath>/money-in-the-banana-stand',
            'to' => 'money-in-the-banana-stand',
        ],
")
      end
    end
  end

  describe ".get_filenames" do
    describe "given file list with no actual files" do
      it "creates empty string" do
        expect(@manifester.get_filenames("")).to eq("")
      end
    end

    describe "given file list" do
      it "creates array of filenames" do
        FakeFS.with_fresh do
          file_with_pathnames = 'list_of_files.txt'
          file_contents = "path/to/fountain-of-strewth\npath/to/reality"
          File.open(file_with_pathnames, 'w') {|f| f.write(file_contents)}
          expect(@manifester.get_filenames(file_with_pathnames)).to eq(["path/to/fountain-of-strewth", "path/to/reality"])
        end
      end
    end
  end

  describe "chaining get_filenames, generate_copy_lines, install_defs" do
    it "creates copydef generated block installdef" do
      FakeFS.with_fresh do
        file_with_pathnames = 'list_of_files.txt'
        file_contents = "path/to/fountain-of-strewth\npath/to/reality"
        File.open(file_with_pathnames, 'w') {|f| f.write(file_contents)}
        copylines = @manifester.get_filenames(file_with_pathnames)
        copydef = @manifester.generate_copy_lines(copylines)

        expect(@manifester.install_defs(copydef)).to eq("$installdefs = [
    'id' => strtolower(preg_replace('/([^a-zA-Z0-9])/', '-', $key.'_'.$package_name)),
    'copy' => [
        [
            'from' => '<basepath>/path/to/fountain-of-strewth',
            'to' => 'path/to/fountain-of-strewth',
        ],
        [
            'from' => '<basepath>/path/to/reality',
            'to' => 'path/to/reality',
        ],
    ]
];
")
      end
    end
  end
end

