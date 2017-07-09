S3_STORAGE = Fog::Storage.new(
  provider: 'AWS',
  region: 'us-east-2',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)
