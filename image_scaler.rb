#!/usr/bin/env ruby
require 'slop'
require_relative 'lib/image_scaler'

options = Slop.new help: true do
  banner 'Usage: image_scaler.rb source_dir destination_dir [options]'

  on 'w', 'width', 'Width of output images', argument: true, required: true
  on 'h', 'height', 'Height of output images', argument: true, required: true
end

begin
  options.parse
rescue Slop::Error => e
  puts e.message
  puts options
  exit 1
end

source_dir = ARGV[0]
unless Dir.exists? source_dir
  puts "Source directory '#{source_dir}' doesn't exist"
  exit 1
end

destination_dir = ARGV[1]

ImageScaler.rescale_dir source_dir, destination_dir, options[:height], options[:height]
