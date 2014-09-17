require 'test_helper'
require_relative '../image_scaler'

class ImageScalerTest < ActiveSupport::TestCase
  test "output_file_name should return the correct file name" do
    assert_equal 'picture.jpg', ImageScaler.output_file_name('/path/to/picture.jpg')
    assert_equal 'picture_cr2.jpg', ImageScaler.output_file_name('/path/to/picture.CR2')
  end
end