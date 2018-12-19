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


## License

Released under [BSD 3-Clause](./LICENSE).
