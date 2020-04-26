require 'json'

def write_json(struct, path)
  json = JSON.generate(struct.to_h)
  File.open(path,"w") do |file|
    file.write(json)
  end
end
