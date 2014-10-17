require 'rubygems'
require 'json'
require 'pp'

# Read the raw file
raw = File.read( 'raw.json' )

# Convert and clean up the file to JSON
converted = JSON.parse( raw )
# Find title, author, book_page_url

num_of_pages = converted.count
puts "num_of_pages: #{num_of_pages} \n"

i = 0
num_of_books = 0

until i == num_of_pages 
	until num_of_books == 12 # each page has 12 books
		puts converted[i][num_of_books]['title'] + " | " + converted[i][num_of_books]['author'] + " | " + converted[i][num_of_books]["book_page_url"]
		num_of_books += 1
	end
	puts "\n Finished page #{i} \n"
	i += 1
	
	# Reset num_of_books
	num_of_books = 0
end