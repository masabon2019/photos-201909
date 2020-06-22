class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

include Cloudinary::CarrierWave

  process :convert => 'png'
  process :tags => ['avatar']

  version :standard do
    process :resize_to_fill => [100, 150, :north]
  end

  version :photo_thumbnail do
    process :resize_to_fill => [480, 360, :center]
  end

  version :prof_thumbnail do
    process :resize_to_fill => [180, 180, :center]
  end

  def size_range
    1..3.megabytes
  end

  def public_id
    return model.id
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def default_url(*args)
    "default.jpg"
  end

  #def content_type_whitelist
  #    [/image\//]
  #  end
  end
