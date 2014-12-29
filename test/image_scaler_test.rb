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

    test "should not remove files from destination directory that doesn't exist in source directory if delete option not set" do
      Dir.mktmpdir do |dir|
        test_file_1 = File.join(dir, 'file.txt')
        test_file_2 = File.join(dir, 'dinosaurs', 'file.txt')
        FileUtils.touch(test_file_1)
        Dir.mkdir(File.join(dir, 'dinosaurs'))
        FileUtils.touch(test_file_2)

        ImageScaler.rescale_dir('test/files', dir, 640, 480, {})

        assert File.exists?(test_file_1), 'This file doesn\'t exist in the source directory so it should have been removed'
        assert File.exists?(test_file_2), 'This file doesn\'t exist in the source directory so it should have been removed'
      end
    end

    test "should remove files from destination directory that doesn't exist in source directory if delete option is set" do
      Dir.mktmpdir do |dir|
        test_file_1 = File.join(dir, 'file.txt')
        test_file_2 = File.join(dir, 'dinosaurs', 'file.txt')
        FileUtils.touch(test_file_1)
        Dir.mkdir(File.join(dir, 'dinosaurs'))
        FileUtils.touch(test_file_2)

        ImageScaler.rescale_dir('test/files', dir, 640, 480, {delete: true})

        refute File.exists?(test_file_1), 'This file doesn\'t exist in the source directory so it should have been removed'
        refute File.exists?(test_file_2), 'This file doesn\'t exist in the source directory so it should have been removed'
      end
    end
  end

  class RemoveExtraFilesFromDistination < ActiveSupport::TestCase
    test "should remove files from destination directory that doesn't exist in source directory" do
      Dir.mktmpdir do |source_dir|
        Dir.mktmpdir do |destination_dir|
          FileUtils.touch(File.join(source_dir, 'file1.jpg'))
          FileUtils.touch(File.join(destination_dir, 'file2.jpg'))

          ImageScaler.remove_extra_files_from_distination source_dir, destination_dir

          refute File.exists?(File.join(destination_dir, 'file2.jpg')), 'This file doesn\'t exist in the source directory so it should have been removed'
        end
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

  class SkipFile < ActiveSupport::TestCase
    test "should not skip files when destination file does not exist" do
      refute ImageScaler.skip_file?('/does_not_exist.jpg', '')
    end

    test "should not skip files when the destination file does not have the same config string as the source file" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/arch.png', dir, 640, 480)

        refute ImageScaler.skip_file?(output_file_path, 'wrong config string')
      end
    end

    test "should skip files when the destination file has the same config string as the source file" do
      Dir.mktmpdir do |dir|
        output_file_path = ImageScaler.rescale_image('test/files/arch.png', dir, 640, 480)

        assert ImageScaler.skip_file?(output_file_path, '0e08d99c01b66845351514f0ccac33b442ee9393,640,480,85')
      end
    end
  end
end