require 'lisbn'
require 'isbn/tools'
require 'json'
require 'csv'

@dataset = []

File.readlines('data/isbn_source.txt', encoding: 'UTF-8').each do |line|
	isbn = Lisbn.new(line.rstrip)
	hashed = Hash.new

	if isbn.valid? 
		hashed["isbn"] = isbn
		hashed["validity"] = isbn.valid?
		hashed["gs1_prefix"] = isbn.parts[0]
		hashed["country_code"] = isbn.parts[1]
		hashed["publisher_code"] = isbn.parts[2]
		hashed["item_number"] = isbn.parts[3]
		hashed["check_digit"] = isbn.parts[4]
		hashed["gs1_country_publisher"] = [isbn.parts[0], isbn.parts[1], isbn.parts[2]].join('-')

		puts " #{isbn} \t #{isbn.valid?} \t #{hashed}"

		@dataset << hashed	
	else
		cksum = ISBN_Tools.compute_check_digit(isbn)
		abort "INVALID ISBN FOUND! #{isbn} Checksum should be #{cksum}"
	end
	
	
end

puts @dataset
puts @dataset.size

CSV.open('data/isbn_results.csv', 'wb') do |csv|
	csv << @dataset.first.keys
	@dataset.each do |hash|
		csv << hash.values
	end
end