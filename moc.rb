require 'open-uri'
require 'httparty'

def download_image(url, dest)
  open(url) do |u|
    File.open(dest, 'wb') { |f| f.write(u.read) }
  end
end

response = HTTParty.get("https://www.vam.ac.uk/api/json/museumobject/search?q=museum+of+childhood%22+toys")

images = response['records'].collect{ |r| r['fields']['primary_image_id'] }
urls = images.collect{ |i| "http://media.vam.ac.uk/media/thira/collection_images/#{i[0..5]}/#{i}_jpg_ds.jpg" }
urls.each { |url| download_image(url, 'images/' + url.split('/').last) }

`./pummelize.sh images`
