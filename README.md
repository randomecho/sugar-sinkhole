# Sugar sinkhole

Scripts, generators, whatever in terms of smoothing
out working in Sugar.


## Scripts

- [sugar-manifest.rb](./sugar-manifest.rb)

  Generates a boilerplate manifest.php file. If a list of filenames
  is used as an argument it will also create the copy block under
  the installdefs section.

- [sugar-packer.rb](./sugar-packer.rb)

  Reads from a manifest.php file and attempts fetch all the listed files
  necessary for the Module Loader package.

- [Vagrant config setter](./vagrant-config.sh)

  Update config.php to use values expected if using vagrant box from Sugar.

  Example result:

        array (
            'db_host_name' => 'localhost', // 10.3.2.1,
            'db_user_name' => 'root', // original_username,
            'db_password' => 'root', // original_password,

## Tests

Some files have tests:

    rspec


## License

Released under [BSD 3-Clause](./LICENSE).
