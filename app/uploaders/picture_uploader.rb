class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # require 'RMagick'
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process :crop
  process resize_to_limit: [300, 300]
  # process :create_square

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

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

    # def crop
    #   manipulate! do |img|
    #     length = img[:width] > img[:height] ? img[:height] : img[:width]
    #     side = length/2
    #     img.crop "#{length}x#{length}+100+0"
    #     # img.resize "#{length}x#{length}"
    #     img
    #   end
    # end
    #
    def crop
      manipulate! do |image|
        w = image[:width]
        h = image[:height]
        if w < h
          remove = ((h - w)/2).round
          image.shave("0x#{remove}")
        elsif w > h
          remove = ((w - h)/2).round
          image.shave("#{remove}x0")
        end

      end
    end

    # def create_square
    #   manipulate! do |img|
    #     narrow = img.columns > img.rows ? img.rows : img.columns
    #     img.crop(Magick::CenterGravity, narrow, narrow).resize(size, size)
    #   end
    # end

end
