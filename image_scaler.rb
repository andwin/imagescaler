require 'RMagick'
include Magick

class ImageScaler
  def self.rescale_image source_path, output_dir, width, height
    img = Image.read(source_path).first()
    scaled_image = img.resize_to_fit(width, height)
    output_path = File.join(output_dir, output_file_name(source_path))
    scaled_image.write(output_path)
    return output_path
  end

  def self.output_file_name source_path
    basename = File.basename(source_path)
    extension = File.extname(basename).downcase.sub('.', '')

    return basename if extension == 'jpg'

    return File.basename(basename, File.extname(basename)) + "_" + extension + '.jpg'
  end
end