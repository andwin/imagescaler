[![Build Status](https://travis-ci.org/andwin/imagescaler.svg?branch=master)](https://travis-ci.org/andwin/imagescaler)
# ImageScaler
Command line utillity to rescale photo collections

## Setup
You need to have [Ruby](https://www.ruby-lang.org/en/) and [ImageMagick](http://www.imagemagick.org/) installed.
```
# Arch
pacman -S imagemagick

# Ubuntu/Debian
apt-get install imagemagick

# Mac
brew install imagemagick
```

To rescale raw files you need to install [UFRaw](http://ufraw.sourceforge.net/)
```
# Arch
pacman -S gimp-ufraw

# Ubuntu
apt-get install ufraw

# Mac
brew install ufraw
```

Install the ruby dependencies by running
```
bundle
```

## Tests
Run the tests like this:
```
rake test
```
