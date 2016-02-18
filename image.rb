require 'open-uri'
require 'mechanize'
require 'phashion'


img1 = Phashion::Image.new('1.jpg')
img2 = Phashion::Image.new('2.jpg')
img3 = Phashion::Image.new('3.jpg')
img4 = Phashion::Image.new('4.jpg')
img5 = Phashion::Image.new('5.jpg')


puts img1.distance_from(img2)
puts img1.distance_from(img3)
puts img1.distance_from(img4)
puts img1.distance_from(img5)

puts '----'

puts img1.fingerprint
puts img2.fingerprint
puts img3.fingerprint
puts img4.fingerprint
puts img5.fingerprint


file = 'http://exmoorpet.com/wp-content/uploads/2012/08/cat.png'

File.open("sample.png", 'wb') do |f|
	f.print open(file).read
end

sample = Phashion::Image.new("sample.png")
puts sample.fingerprint


puts img1.distance_from(sample)


agent = Mechanize.new
page = agent.get('http://orights.com/books/klein-wit-visje-9789044819274')
cover_image = page.search("img.image").first

agent.get(cover_image.attributes['src']).save "downloaded.png"

downloaded = Phashion::Image.new("downloaded.png")
puts downloaded.fingerprint
puts img1.distance_from(downloaded)