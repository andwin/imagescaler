[![Build Status](https://travis-ci.org/andwin/imagescaler.svg?branch=master)](https://travis-ci.org/andwin/imagescaler)
# ImageScaler
Command line utillity to rescale photo collections

## Setup
You need to have ruby and [image magic](http://www.imagemagick.org/) installed.
```
# Arch
pacman -S imagemagick

# Ubuntu/Debian
apt-get install imagemagick

# Mac
brew install imagemagick
```

To rescale raw files you need to install ufraw
```
#arch
pacman -S gimp-ufraw

#ubuntu
apt-get install ufraw

#mac
brew install ufraw
```

Install dependencies by running
```
bundle
```

## Tests
Run the tests like this:
```
rake test
```
