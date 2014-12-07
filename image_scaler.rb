#!/usr/bin/env ruby
require 'slop'
require_relative 'lib/image_scaler'

options = Slop.new help: true do
  banner 'Usage: image_scaler.rb source_dir destination_dir [options]'

  on 'width', 'Width of output images', argument: true, required: true, as: Integer
  on 'height', 'Height of output images', argument: true, required: true, as: Integer
  on 'q', 'quality', 'Output image quality', argument: true, as: Integer
  on 'd', 'delete', 'Delete extra files from distination'
  on 'v', 'verbose', 'Verbose output'
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

if options[:verbose]
  puts 'Source directory: ' + source_dir
  puts 'Destination directory: ' + destination_dir
  options.to_hash.each do |key, value|
    unless value.nil?
      puts key.to_s + ': ' + value.to_s
    end
  end
  puts
end

ImageScaler.rescale_dir source_dir, destination_dir, options[:width], options[:height], options.to_hash
