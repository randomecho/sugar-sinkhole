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
end

