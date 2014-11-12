require 'tmpdir'
require 'test_helper'
require 'RMagick'
require_relative '../image_scaler'
include Magick

class ImageScalerTest < ActiveSupport::TestCase
  class ScalerImage < ActiveSupport::TestCase
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
  end

  test "should return expected file name" do
    assert_equal 'picture.jpg', ImageScaler.output_file_name('/path/to/picture.jpg')
    assert_equal 'picture_cr2.jpg', ImageScaler.output_file_name('/path/to/picture.CR2')
  end
end