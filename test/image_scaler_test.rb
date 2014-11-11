require 'tmpdir'
require 'fastimage'
require 'test_helper'
require_relative '../image_scaler'

class ImageScalerTest < ActiveSupport::TestCase
  class ScalerImage < ActiveSupport::TestCase
    test "should keep aspect rato of portrait image" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/oops.jpg', dir, 640, 480)
        width, heigth = FastImage.size(output_file_path)

        assert_equal 358, width
        assert_equal 480, heigth
      end
    end

    test "should keep aspect ratio of landscape image" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/never-forget.jpg', dir, 640, 480)
        width, heigth = FastImage.size(output_file_path)

        assert_equal 640, width
        assert_equal 203, heigth
      end
    end
  end

  test "should return expected file name" do
    assert_equal 'picture.jpg', ImageScaler.output_file_name('/path/to/picture.jpg')
    assert_equal 'picture_cr2.jpg', ImageScaler.output_file_name('/path/to/picture.CR2')
  end
end