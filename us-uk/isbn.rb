require 'lisbn'
require 'isbn/tools'
require 'json'
require 'csv'


def extract_isbn(string)
	string.match('\d{13}').to_s
end

@dataset = []
@fixed_count = 0

File.open('/Users/jungdolee/projects/importer/data/isbn_source.txt', encoding: 'UTF-8').each do |row|
	puts row = row.rstrip.inspect
	extracted_isbn = extract_isbn(row)

	isbn = Lisbn.new(extracted_isbn)
	hashed = Hash.new


	if isbn.valid? 
		puts isbn
		if isbn.parts
			hashed["isbn_original"] = isbn
			hashed["isbn_fixed"] = isbn
			hashed["gs1_prefix"] = isbn.parts[0]
			hashed["country_code"] = isbn.parts[1]
			hashed["publisher_code"] = isbn.parts[2]
			hashed["item_number"] = isbn.parts[3]
			hashed["check_digit"] = isbn.parts[4]
			hashed["gs1_country_publisher"] = [isbn.parts[0], isbn.parts[1], isbn.parts[2]].join('-')
			hashed["remarks"] = "valid"

			puts "DONE: #{isbn} \t #{hashed}"

			@dataset << hashed
		else
			# Something is wrong; maybe isbn is not sliceable
			hashed["isbn_original"] = isbn
			hashed["isbn_fixed"] = isbn
			hashed["gs1_prefix"] = 'ERROR'
			hashed["country_code"] = 'ERROR'
			hashed["publisher_code"] = 'ERROR'
			hashed["item_number"] = 'ERROR'
			hashed["check_digit"] = 'ERROR'
			hashed["gs1_country_publisher"] = 'ERROR'
			hashed["remarks"] = "invalid"

			puts "DONE: #{isbn} \t #{hashed}"

			@dataset << hashed
		end

	
	else
		# Replace the last digit(check digit) with the fixed one and save to hash
		fixed_check_digit = ISBN_Tools.compute_check_digit(isbn)
		# First, drop the last digit from the given isbn
		isbn_fixed = isbn.chop
		# Next, join 
		isbn_fixed = [isbn_fixed, fixed_check_digit].join('')
		# Start a new Lisbn instance with the isbn_fixed
		# Otherwise, the parts method that inherits from Lisbn instance is not usable
		isbn_fixed = Lisbn.new(isbn_fixed)
					

		hashed["isbn_original"] = isbn
		hashed["isbn_fixed"] = isbn_fixed
		hashed["gs1_prefix"] = isbn_fixed.parts[0]
		hashed["country_code"] = isbn_fixed.parts[1]
		hashed["publisher_code"] = isbn_fixed.parts[2]
		hashed["item_number"] = isbn_fixed.parts[3]
		hashed["check_digit"] = fixed_check_digit
		hashed["gs1_country_publisher"] = [isbn_fixed.parts[0], isbn_fixed.parts[1], isbn_fixed.parts[2]].join('-')
		hashed["remarks"] = "fixed"
		
		puts "FIXED: #{isbn} \t #{hashed}"
		@dataset << hashed
		
		@fixed_count += 1
	end
	
	
end

puts "Successfully processed #{@dataset.size} isbns! \nFixed #{@fixed_count} isbns. Refer to remarks column." 


# Write the results to CSV
CSV.open('/Users/jungdolee/projects/importer/data/isbn_results.csv', 'wb') do |csv|
	csv << @dataset.first.keys
	@dataset.each do |hash|
		csv << hash.values
	end
end

