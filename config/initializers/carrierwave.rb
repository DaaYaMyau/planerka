CarrierWave.configure do |config|
  config.root = Rails.root.join("tmp") if Rails.env.test?
end
