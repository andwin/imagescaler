require 'tmpdir'
require 'test_helper'
require 'RMagick'
require_relative '../lib/image_scaler'
include Magick

class ImageScalerTest < ActiveSupport::TestCase
  class RescaleDir < ActiveSupport::TestCase
    test "should create all image files in output directory" do
      Dir.mktmpdir do |dir|
        ImageScaler.rescale_dir('test/files', dir, 640, 480, {})

        assert_equal ['.', '..', 'arch_png.jpg', 'dinosaurs', 'never-forget.jpg', 'oops.jpg', 'toad.jpg'].sort, Dir.entries(dir).sort
        assert_equal ['.', '..', 'dinosaur.jpg'].sort, Dir.entries(File.join(dir, 'dinosaurs')).sort
      end
    end

    test "should send all options to rescale_image for every image" do
      Dir.mktmpdir do |dir|
        quality = 50
        ImageScaler.rescale_dir('test/files', dir, 640, 480, {quality: quality})

        output_image = Image.read(File.join(dir, 'arch_png.jpg')).first()

        assert_equal quality, output_image.quality
      end
    end
  end

  class RescaleImage < ActiveSupport::TestCase
    test "should keep aspect rato of portrait image" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/oops.jpg', dir, 640, 480)
        output_image = Image.read(output_file_path).first()

        assert_equal 358, output_image.columns
        assert_equal 480, output_image.rows
      end
    end

    test "should keep aspect ratio of landscape image" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/never-forget.jpg', dir, 640, 480)
        output_image = Image.read(output_file_path).first()

        assert_equal 640, output_image.columns
        assert_equal 203, output_image.rows
      end
    end

    test "should scale up smaller images" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/toad.jpg', dir, 640, 480)
        output_image = Image.read(output_file_path).first()

        assert_equal 640, output_image.columns
        assert_equal 480, output_image.rows
      end
    end

    test "should work with png images" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/arch.png', dir, 640, 480)
        output_image = Image.read(output_file_path).first()

        assert_equal 'arch_png.jpg', File.basename(output_file_path)
        assert_equal 480, output_image.columns
        assert_equal 480, output_image.rows
      end
    end

    test "should use default image quality if not specified" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/arch.png', dir, 640, 480)
        output_image = Image.read(output_file_path).first()

        assert_equal 85, output_image.quality
      end
    end

    test "should use specified quality" do
      Dir.mktmpdir do |dir|
        quality = 50
        output_file_path = ImageScaler.rescale_image('test/files/arch.png', dir, 640, 480, {quality: quality})
        output_image = Image.read(output_file_path).first()

        assert_equal quality, output_image.quality
      end
    end
  end

  class OutputFileName < ActiveSupport::TestCase
    test "should return expected file name" do
      assert_equal 'picture.jpg', ImageScaler.output_file_name('/path/to/picture.jpg')
      assert_equal 'picture_cr2.jpg', ImageScaler.output_file_name('/path/to/picture.CR2')
    end
  end
end