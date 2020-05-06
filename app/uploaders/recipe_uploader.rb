class RecipeUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "#{Rails.env}"
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
