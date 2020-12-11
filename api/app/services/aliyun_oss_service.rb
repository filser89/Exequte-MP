require 'aliyun/sts'
require 'aliyun/oss'
class AliyunOssService
  TEST_BUCKET = 'exequte-test'.freeze

  STS = Aliyun::STS::Client.new(
    access_key_id:
    Rails.application.credentials.aliyun_access_key_id,
    access_key_secret:
    Rails.application.credentials.aliyun_access_key_secret
  )

  def self.client(token)
    Aliyun::OSS::Client.new(
      endpoint: Rails.application.credentials.aliyun_endpoint,
      access_key_id: token.access_key_id,
      access_key_secret: token.access_key_secret,
      sts_token: token.security_token
    )
  end

  def self.fetch_token
    policy = Aliyun::STS::Policy.new
    policy.allow(['oss:*'], ["acs:oss:*:1557106377546687:#{TEST_BUCKET}/*"])
    STS.assume_role('acs:ram::1557106377546687:role/exequte-oss-full', 'client-01', policy, 15 * 60)
  end

  def self.upload(file, filename = SecureRandom.hex(16), bucket = TEST_BUCKET)
    client = client(fetch_token)
    bucket = client.get_bucket(bucket)
    bucket.put_object(filename, file: file.path)
  end

  def self.signed_url(key, expires_in = 120, bucket = TEST_BUCKET)
    client = client(fetch_token)
    bucket = client.get_bucket(bucket)
    url = bucket.object_url(key, false)
    puts "URL"
    p url
    resource = "/#{bucket.name}/#{key}"
    puts "resource"
    p resource
    expires  = Time.now.to_i + expires_in
    query    = {
      "Expires" => expires,
      "OSSAccessKeyId" => Rails.application.credentials.aliyun_access_key_id
    }
    string_to_sign = ["GET", "", "", expires, resource].join("\n")
    puts "String to sign #{string_to_sign}"
    query["Signature"] = bucket.sign(string_to_sign)
    [url, query.to_query].join('?')
  end

  # def object_url(key, sign:, expires_in: 60, params: {})
  #     client = client(fetch_token)
  #     bucket = client.get_bucket(bucket)
  #       url = bucket.object_url(key, false)
  #       unless sign
  #         return url if params.blank?
  #         return url + "?" + params.to_query
  #       end

  #       resource = "/#{bucket.name}/#{key}"
  #       expires  = Time.now.to_i + expires_in
  #       query    = {
  #         "Expires" => expires,
  #         "OSSAccessKeyId" => Rails.application.credentials.aliyun_access_key_id
  #       }


  #       if params.present?
  #         resource += "?" + params.map { |k, v| "#{k}=#{v}" }.sort.join("&")
  #       end

  #       string_to_sign = ["GET", "", "", expires, resource].join("\n")
  #       query["Signature"] = bucket.sign(string_to_sign)

  #       [url, query.to_query].join('?')
  #     end
end

# token = AliyunOssService.fetch_token
# client = AliyunService.client(token)
url =
  'https://s5o.ru/storage/simple/ru/edt/90/50/f5/37/rue5f231c5949.jpg'
file = FileDownloaderService.download(url)
filename = "#{SecureRandom.hex(16)}.jpeg"
AliyunOssService.upload(file, filename)

AliyunOssService.signed_url(filename)


bucket = AliyunOssService.client(AliyunOssService.fetch_token).get_bucket(AliyunOssService::TEST_BUCKET)
