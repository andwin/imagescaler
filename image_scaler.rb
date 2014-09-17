class ImageScaler
  def self.output_file_name source_path
    basename = File.basename(source_path)
    extension = File.extname(basename).downcase.sub('.', '')

    return basename if extension == 'jpg'

    return File.basename(basename, File.extname(basename)) + "_" + extension + '.jpg'
  end
end