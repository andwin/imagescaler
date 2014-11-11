require 'tmpdir'
require 'fastimage'
require 'test_helper'
require_relative '../image_scaler'

class ImageScalerTest < ActiveSupport::TestCase
  class ScalerImage < ActiveSupport::TestCase
    test "scaling a portrait image should keep aspect ratio" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/oops.jpg', dir, 640, 480)
        width, heigth = FastImage.size(output_file_path)

        assert_equal 358, width
        assert_equal 480, heigth
      end
    end
  end

  test "output_file_name should return the correct file name" do
    assert_equal 'picture.jpg', ImageScaler.output_file_name('/path/to/picture.jpg')
    assert_equal 'picture_cr2.jpg', ImageScaler.output_file_name('/path/to/picture.CR2')
  end
end