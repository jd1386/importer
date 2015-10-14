require 'spreadsheet'
require 'colorize'
require 'lisbn'



def format_isbn(row_hash)
	row_hash["EAN"]
end

def format_isbn_prefix(row_hash)
	isbn = Lisbn.new(format_isbn(row_hash).to_i.to_s)
	hashed = {}

	hashed["isbn_original"] = isbn
	hashed["isbn_fixed"] = isbn
	hashed["gs1_prefix"] = isbn.parts[0]
	hashed["country_code"] = isbn.parts[1]
	hashed["publisher_code"] = isbn.parts[2]
	hashed["item_number"] = isbn.parts[3]
	hashed["check_digit"] = isbn.parts[4]
	hashed["gs1_country_publisher"] = [isbn.parts[0], isbn.parts[1], isbn.parts[2]].join('-')

	return hashed["gs1_country_publisher"]


end

def format_title(row_hash)
	# First, split with '(' to have title_primary separated from format
		title_primary = row_hash["title_primary"].split(' (').first
		@format_raw = row_hash["title_primary"].split(' (').last.gsub(')', '')
	
	# Join cleaned title_primary and title_secondary
	if row_hash["title_secondary"] == 'N/A'
		full_title_original = title_primary
	else
		full_title_original = title_primary + ': ' + row_hash["title_secondary"]
	end
	
	# Remove 'N/A'
		full_title_original.gsub(' N/A', '')
end

def format_format(format_raw)
	format_raw
end


def format_author(row_hash)
	# author_secondary lists only translator info 
	# when single => Übersetzung: Bettina Bach
	# and when multiple it's format is => Übersetzung: Bettina Bach, Lisa-Maria Rust
	# We need to make it the other way
	
	author_secondary_role = row_hash["author_secondary"].split(': ').first.gsub("Übersetzung", "Translator")
	author_secondary_name = row_hash["author_secondary"].split(': ').last
	author_secondary_cleaned = author_secondary_name + " (" + author_secondary_role + ")"

		# author_primary
		if row_hash["author"].nil?
			author_primary_cleaned = nil
		else
			author_primary_role = 'Author'
			author_primary_name = row_hash["author"]
			author_primary_cleaned = author_primary_name + " (" + author_primary_role + ")"
		end

		# Combine author_primary and author_secondary
		if author_primary_cleaned.nil?
			authors = author_secondary_cleaned
		else
			authors = author_primary_cleaned + ", " + author_secondary_cleaned
		end
	

	# Last clean up
	authors.gsub!(', N/A (N/A)', '')

	return authors
end

def format_book_page_url(row_hash)
	row_hash["link_to_book"]
end

def format_pub_date(row_hash)
	# pub_date is d.m.Y
	if row_hash["pub_date"].is_a? String
		Date.strptime(row_hash["pub_date"], '%d.%m.%Y').strftime('%Y-%m-%d')
	# pub_date is only m.Y
	elsif row_hash["pub_date"].is_a? Float
		Date.strptime(row_hash["pub_date"].to_s, '%m.%Y').strftime('%Y-%m-%d')
	end

end

def format_image_link(row_hash)
	if row_hash["image"].to_s.include? 'nopic.jpg'
		''
	else
		row_hash["image"]
	end
end

def format_publisher(row_hash)
	row_hash["publisher"]
end

def format_book_description(row_hash)
	row_hash["description"]
end

def format_pages(row_hash)
	row_hash["pages"]
end

def format_language(row_hash)
	if row_hash["language"] == "deutsch"
		"German"
	else
		"Other"
	end
	
end

def format_is_translated(row_hash)
	if format_author(row_hash).include? "Translator"
		'True'
	elsif !row_hash["original_title"].nil?
		'True'
	else
		'False'
	end
end

def format_category_all(row_hash)
	row_hash["category"]
end

# Goal ###
# isbn	isbn_prefix	title_original	title_translated	
# language_detected	 author	image_link	book_page_url		
# pub_date format publisher	company_listed		
# publisher_final	publisher_country	book_description	pages		
# series	language is_translated	category_all	source

Spreadsheet.client_encoding = 'UTF-8'

# Read xls source file
book_source = Spreadsheet.open 'cleaner_source.xls'
sheet1 = book_source.worksheet 0
book_output = Spreadsheet::Workbook.new
sheet2 = book_output.create_worksheet


# Write output file's header
sheet2.row(0).replace [ 
	'isbn', 'isbn_prefix', 'title_original', 'title_translated',
	 'language_detected', 'author', 'image_link', 'book_page_url', 
	 'pub_date', 'format', 'publisher', 'company_listed',
	 'publisher_final', 'publisher_country', 'book_description', 'pages',
	 'series', 'language', 'is_translated', 'category_all', 'source'
]


# Make a hash for every row
sheet1.each_with_index 1 do |row, rindex|
	@row_hash = {}

	row.each_with_index do |column, cindex|
		# Make header value the hash key and cell value the hash value
		@row_hash[sheet1[0,cindex]] = column
	end

	puts rindex.to_s.red
	puts @row_hash

	
	# Get cleaned column
	isbn = format_isbn(@row_hash)
	isbn_prefix = format_isbn_prefix(@row_hash)
	title_original = format_title(@row_hash)
	title_translated = '' # We don't have this yet.

	language_detected = '' # We don't have this yet.
	author = format_author(@row_hash)
	image_link = format_image_link(@row_hash)
	book_page_url = format_book_page_url(@row_hash)

	pub_date = format_pub_date(@row_hash)
	format = format_format(@format_raw)
	publisher = format_publisher(@row_hash)
	company_listed = ''

	publisher_final = ''
	publisher_country = ''
	book_description = format_book_description(@row_hash)
	pages = format_pages(@row_hash)

	series = ''
	language = format_language(@row_hash)
	is_translated = format_is_translated(@row_hash)
	category_all = format_category_all(@row_hash)
	source = 'Germany'


	# Add every column to output file
	sheet2.row(rindex+1).replace [ 
		isbn, isbn_prefix, title_original, title_translated, 
		language_detected, author, image_link, book_page_url,
		pub_date, format, publisher, company_listed,
		publisher_final, publisher_country, book_description, pages,
		series, language, is_translated, category_all, source
	] 

end

	




# Write the output
book_output.write 'cleaner_output.xls'

