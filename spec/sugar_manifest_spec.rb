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
end

