class PictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  process :square_trimming
  process resize_to_limit: [400, 400]

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  private

    def square_trimming
      manipulate! do |image|
        w = image[:width]
        h = image[:height]
        if w < h
          cut = ((h - w)/2).round
          image.shave("0x#{cut}")
        elsif w > h
          cut = ((w - h)/2).round
          image.shave("#{cut}x0")
        end
      end
    end

end
