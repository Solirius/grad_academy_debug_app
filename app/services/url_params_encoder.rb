require 'base64'
require 'zlib'

# UrlParamsEncoder provides methods for encoding and decoding URL parameters
# using compression and Base64 encoding for efficient transmission and storage.
class UrlParamsEncoder
  # Encodes parameters by first compressing them using Zlib::Deflate and then
  # Base64 encoding the compressed data to ensure URL safety.
  #
  # Params:
  # - params: A hash of parameters to be encoded.
  #
  # Returns:
  # - String: The URL-safe encoded parameters.
  def self.encode(params)
    compressed_params = Zlib::Deflate.deflate(params.to_param)
    Base64.urlsafe_encode64(compressed_params)
  end

  # Decodes URL-safe encoded parameters by first decoding the Base64 string
  # and then inflating the compressed data using Zlib::Inflate. Finally, it
  # parses the inflated data into a hash using Rack::Utils.parse_nested_query.
  #
  # Params:
  # - encoded_params: The URL-safe encoded string to be decoded.
  #
  # Returns:
  # - Hash: The decoded parameters as a hash.
  def self.decode(encoded_params)
    compressed_params = Base64.urlsafe_decode64(encoded_params)
    inflated_params = Zlib::Inflate.inflate(compressed_params)
    Rack::Utils.parse_nested_query(inflated_params)
  end
end
