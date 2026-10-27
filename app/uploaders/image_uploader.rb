class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips

  storage :file

  process :remove_metadata

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[png jpg jpeg webp]
  end

  def content_type_allowlist
    %r{\Aimage/(png|jpeg|webp)\z}
  end

  def size_range
    1..5.megabytes
  end

  def filename
    "#{secure_token}.#{file.extension.downcase}"
  end

  private

  def remove_metadata
    vips! { |builder| builder.saver(keep: :none) }
  end

  def secure_token
    @secure_token ||= SecureRandom.uuid
  end
end
