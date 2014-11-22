require 'RMagick'
include Magick

class ImageScaler
  def self.run argv
    source_dir = argv[0]
    destination_dir = argv[1]

    rescale_dir source_dir, destination_dir
  end

  def self.rescale_dir source_dir, destination_dir
    Dir.mkdir(destination_dir) unless Dir.exist?(destination_dir)

    Dir.entries(source_dir).each do |filename|
      next if filename.start_with? '.'

      source_path = File.join(source_dir, filename)
      if File.directory?(source_path)
        rescale_dir File.join(source_dir, filename), File.join(destination_dir, filename)
      else
        rescale_image source_path, destination_dir, 640, 480
      end
    end
  end

  def self.rescale_image source_path, destination_dir, width, height
    begin
      img = Image.read(source_path).first()
      scaled_image = img.resize_to_fit(width, height)
      output_path = File.join(destination_dir, output_file_name(source_path))
      scaled_image.write(output_path)
      return output_path
    rescue
    end
  end

  def self.output_file_name source_path
    basename = File.basename(source_path)
    extension = File.extname(basename).downcase.sub('.', '')

    return basename if extension == 'jpg'

    return File.basename(basename, File.extname(basename)) + '_' + extension + '.jpg'
  end
end
