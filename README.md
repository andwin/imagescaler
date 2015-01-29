[![Build Status](https://travis-ci.org/andwin/imagescaler.svg?branch=master)](https://travis-ci.org/andwin/imagescaler)
# ImageScaler
Command line utillity to rescale photo collections

## Setup
You need to have [Ruby](https://www.ruby-lang.org/en/) and [ImageMagick](http://www.imagemagick.org/) installed.
```
# Arch
pacman -S imagemagick

# Ubuntu/Debian
apt-get install imagemagick libmagickwand-dev

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

## Usage

```
./image_scaler.rb 
Usage: image_scaler.rb source_dir destination_dir [options]
        --width        Width of output images
        --height       Height of output images
    -q, --quality      Output image quality
    -d, --delete       Delete extra files from distination
    -v, --verbose      Verbose output
    -h, --help         Display this help message.
```

```
image_scaler.rb  ~/Pictures/album/ ~/Pictures/resized/ --width 2560 --height 1440 -v -d
```

## Tests
Run the tests like this:
```
rake test
```
