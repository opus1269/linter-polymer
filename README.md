linter-polymer
=========================

[![Plugin installs!](https://img.shields.io/apm/dm/linter-polymer.svg?style=flat-square)](https://atom.io/packages/linter-polymer)
[![Package version!](https://img.shields.io/apm/v/linter-polymer.svg?style=flat-square)](https://atom.io/packages/linter-polymer)

This plugin for [linter](https://github.com/atom-community/linter) provides an interface to [polylint](https://github.com/PolymerLabs/polylint). It will lint HTML files

## Installation
The Linter package must be installed in order to use this plugin. If it isn't installed, please follow the instructions [here](https://github.com/atom-community/linter#how-to--installation).

### Plugin installation
```sh
$ apm install linter-polymer
```

## Settings
You can configure linter-polymer by editing `~/.atom/config.cson` (choose Open Your Config in Atom menu):
```coffee
'linter-polymer':
  # Lint files while typing, without the need to save
  lintOnFly: true

  # Name of the bower directory
  bowerDir: 'bower_components'

  # Display messages for all imported files
  allMessages: false
```

## Contributing
If you would like to contribute enhancements or fixes, please do the following:

1. Fork the plugin repository
2. Hack on a separate topic branch created from the latest `master`
3. Commit and push the topic branch
4. Make a pull request
5. Welcome to the club :sunglasses:

Please note that modifications should follow these coding guidelines:

- Indent of 2 spaces
- Code should pass [CoffeeLint](http://www.coffeelint.org/) with the provided `coffeelint.json`
- Vertical whitespace helps readability, don't be afraid to use it

**Thank you for helping out!**
