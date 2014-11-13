require 'RMagick'
include Magick

class ImageScaler
  def self.run argv
    source_dir = argv[0]
    destination_dir = argv[1]

    rescale_dir source_dir, destination_dir
  end

  def self.rescale_dir source_dir, destination_dir
    Dir.entries(source_dir).each do |file_name|
      source_path = File.join(source_dir, file_name)
      puts source_path + ' -> ' + destination_dir
    end
  end

  def self.rescale_image source_path, output_dir, width, height
    img = Image.read(source_path).first()
    scaled_image = img.resize_to_fit(width, height)
    output_path = File.join(output_dir, output_file_name(source_path))
    scaled_image.write(output_path)
    scaled_image.write('/tmp/' + File.basename(output_path))
    return output_path
  end

  def self.output_file_name source_path
    basename = File.basename(source_path)
    extension = File.extname(basename).downcase.sub('.', '')

    return basename if extension == 'jpg'

    return File.basename(basename, File.extname(basename)) + '_' + extension + '.jpg'
  end
end

ImageScaler.run ARGV
