#!/usr/bin/env ruby
require 'slop'
require_relative 'lib/image_scaler'

options = Slop.parse do
  banner 'Usage: image_scaler.rb source_dir destination_dir [options]'

  on 'w', 'width', 'Width of output images', argument: :required
  on 'h', 'height', 'Height of output images', argument: :required
end

source_dir = ARGV[0]
destination_dir = ARGV[1]

ImageScaler.rescale_dir source_dir, destination_dir, options[:height], options[:height]
