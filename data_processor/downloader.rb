require "net/http"
require "uri"

def download(uri, path)
  uri = URI.parse(uri)
  response = Net::HTTP.get_response(uri)
  content = response.body
  open(path, 'w') do |file|
    file << content
  end
end