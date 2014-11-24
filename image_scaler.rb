#!/usr/bin/env ruby
require_relative 'lib/image_scaler'

source_dir = ARGV[0]
destination_dir = ARGV[1]

ImageScaler.rescale_dir source_dir, destination_dir
