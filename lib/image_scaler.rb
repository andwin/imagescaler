require 'fileutils'
require 'RMagick'
include Magick

class ImageScaler
  def self.rescale_dir source_dir, destination_dir, width, height, options
    Dir.mkdir(destination_dir) unless Dir.exist?(destination_dir)
    remove_extra_files_from_distination(source_dir, destination_dir, options) if options[:delete]

    Dir.entries(source_dir).each do |filename|
      next if filename.start_with? '.'

      source_path = File.join(source_dir, filename)
      if File.directory?(source_path)
        rescale_dir File.join(source_dir, filename), File.join(destination_dir, filename), width, height, options
      else
        rescale_image source_path, destination_dir, width, height, options
      end
    end
  end

  def self.remove_extra_files_from_distination source_dir, destination_dir, options={}
    Dir.entries(destination_dir).each do |filename|
      unless File.exists?(File.join(source_dir, filename))
        if options[:verbose]
          puts 'Deleting extra file ' + File.join(destination_dir, filename)
        end

        FileUtils.rm(File.join(destination_dir, filename))
      end
    end
  end

  def self.rescale_image source_path, destination_dir, width, height, options={}
    options[:quality] ||= 85
    begin
      img = Image.read(source_path).first()
      scaled_image = img.resize_to_fit(width, height)
      destination_path = File.join(destination_dir, output_file_name(source_path))
      scaled_image.write(destination_path) { self.quality = options[:quality] }

      if options[:verbose]
        puts source_path + ' => ' + destination_path
      end

      return destination_path
    rescue Exception => e
      puts 'Exception while rescaling image: ' + e.message
    end
  end

  def self.output_file_name source_path
    basename = File.basename(source_path)
    extension = File.extname(basename).downcase.sub('.', '')

    return basename if extension == 'jpg'

    return File.basename(basename, File.extname(basename)) + '_' + extension + '.jpg'
  end
end
