require 'Vacuum'
require 'dotenv'
require 'awesome_print'
require 'csv'
require 'json'
require 'retriable'

Dotenv.load

# Configuration
@request = Vacuum.new('ES')
@request.configure(
	aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
	aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
	associate_tag: ENV['AWS_ASSOCIATE_TAG']
)


# Load isbns to look up
isbns = []

File.readlines('data/amazon_isbns.txt').each do |line|
	isbns << line.rstrip
end

@query_count = 0
@isbns_size = isbns.size


# Query each isbn
isbns.each do |isbn|
	Retriable.retriable do
		@response = @request.item_lookup(
		  query: {
		    'IdType' => 'ISBN',
		    'ItemId' => isbn,
		    'SearchIndex' => 'Books',
		    'ResponseGroup' => 'Large',
		    'MerchantId' => 'Amazon'
		  }
		)
	end

	print isbn

	parsed_response = @response.to_h
	

	if parsed_response["ItemLookupResponse"]["Items"]["Request"].has_key?("Errors")
		@error_message = parsed_response["ItemLookupResponse"]["Items"]["Request"]["Errors"]["Error"]["Message"]
		ap @error_message
		
		# Write to CSV
		CSV.open("data/amazon_results.csv", "a") do |csv|
			csv << [ isbn, @error_message ]
		end

	# No error
	else
		
		# Debugging
		#ap parsed_response
		#abort
		# End debugging

		# Parse

		# Case 1. If MULTIPLE book results found with the given isbn
		# Need to determine which one to scrape
		if parsed_response["ItemLookupResponse"]["Items"]["Item"].is_a? Array
				# Number of items shown as search results
				# Case a. Single book with two duplicate pages, one of which is not maintained
				# Case b. Two books, hard/softcover and ebook.
				item_counts = parsed_response["ItemLookupResponse"]["Items"]["Item"].length

				(0...item_counts).each do |i|
					if parsed_response["ItemLookupResponse"]["Items"]["Item"][i].has_key?("LargeImage") && parsed_response["ItemLookupResponse"]["Items"]["Item"][i]["ItemAttributes"]["Binding"] != "Versión Kindle" 
						
						@item_index = i
					end
				end
		end

		if parsed_response["ItemLookupResponse"]["Items"]["Item"].is_a? Array
			# EAN
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("EAN") ? @ean = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["EAN"] : @ean = "N/A"
			# Title
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("Title") ? @title = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Title"] : @title = "N/A"
			# Author
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("Author") ? @author = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Author"] : @author = "N/A"
			
			# Creator
			@creator_and_role = []
			# creator == contributors, different from author
			if parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].is_a? Hash

				#debug
				print " Single creator"
				# end debug

				# only one set	
				@creator_and_role = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].values.join(' - ')

			# multiple creators
			elsif parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].is_a? Array

				#debug
				print " Multiple creator"
				# end debug

				parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].each do |hash|
					@creator_and_role << hash.values.join(' - ')
					
				end

			# No creators listed
			else 
				@creator_and_role = 'None'
			end

			# Company
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("Publisher") ? @company = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Publisher"] : @company = "N/A"
			# PubDate
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("PublicationDate") ? @pub_date = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["PublicationDate"] : @pub_date = "N/A"
			# Binding
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("Binding") ? @binding = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Binding"] : @binding = "N/A"
			# Number of Pages
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("NumberOfPages") ? @number_of_pages = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["NumberOfPages"] : @number_of_pages = "N/A"
			# Book page url
			parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index].has_key?("DetailPageURL") ? @book_page_url = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["DetailPageURL"] : @book_page_url = "N/A"
			# Cover image
			if parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index].has_key?("LargeImage")
				@cover_image_url = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["LargeImage"]["URL"]
			else
				@cover_image_url = "N/A"
			end
			# Language
			# Most of the time, it's multiple
			if parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("Languages")
				if parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"].is_a? Array
					@language = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"][0]["Name"]
				# Single language
				elsif parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"].is_a? Hash
					@language = parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"]["Name"]
				# Doesn't exist
				else
					@language = "N/A"
				end
			else
				@language = "N/A"
			end

		# Case 2. SINGLE book results with the given isbn
		else
			# EAN
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("EAN") ? @ean = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["EAN"] : @ean = "N/A"
			# Title
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("Title") ? @title = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"] : @title = "N/A"
			# Author
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("Author") ? @author = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Author"] : @author = "N/A"
			
			# Creator
			@creator_and_role = []
			# creator == contributors, different from author
			if parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].is_a? Hash

				#debug
				print " Single creator"
				# end debug

				# only one set	
				@creator_and_role = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].values.join(' - ')

			# multiple creators
			elsif parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].is_a? Array

				#debug
				print " Multiple creator"
				# end debug
				
				parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].each do |hash|
					@creator_and_role << hash.values.join(' - ')
				end

			# otherwise, no creators listed
			else
				@creator_and_role = 'None'
			end

			# Company
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("Publisher") ? @company = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Publisher"] : @company = "N/A"
			# PubDate
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("PublicationDate") ? @pub_date = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["PublicationDate"] : @pub_date = "N/A"
			# Binding
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("Binding") ? @binding = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Binding"] : @binding = "N/A"
			# Number of Pages
			parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("NumberOfPages") ? @number_of_pages = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["NumberOfPages"] : @number_of_pages = "N/A"
			# Book page url
			parsed_response["ItemLookupResponse"]["Items"]["Item"].has_key?("DetailPageURL") ? @book_page_url = parsed_response["ItemLookupResponse"]["Items"]["Item"]["DetailPageURL"] : @book_page_url = "N/A"
			# Cover image
			if parsed_response["ItemLookupResponse"]["Items"]["Item"].has_key?("LargeImage")
				@cover_image_url = parsed_response["ItemLookupResponse"]["Items"]["Item"]["LargeImage"]["URL"]
			else
				@cover_image_url = "N/A"
			end
			# Language
			# Most of the time, it's multiple
			if parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("Languages")
				if parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"].is_a? Array
					@language = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"][0]["Name"]
				# Single language
				elsif parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"].is_a? Hash
					@language = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"]["Name"]
				# Doesn't exist
				else
					@language = "N/A"
				end
			else
				@language = "N/A"
			end

		end
		
		
		##################################################

		# Write the results to CSV
		CSV.open("data/amazon_results.csv", "a") do |csv|
			csv << [ @ean, @title, @company, @author, @creator_and_role, @pub_date, @binding, @number_of_pages, @language, @book_page_url, @cover_image_url ]
		end
	@query_count += 1
	print " ... OK \t #{@query_count} / #{@isbns_size} \n"
	end

end # End File.readlines

puts "All done"

