require 'isbn'

source = []

File.readlines('data/isbn_test_source.txt', encoding: 'UTF-8').each do |line|
	#isbn10 = ISBN.thirteen(line)
	# puts ISBN.valid?(isbn10)

end