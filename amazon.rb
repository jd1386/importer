require 'Vacuum'
require 'dotenv'
require 'awesome_print'
require 'csv'
require 'json'
require 'retriable'

def which_item
		if @parsed_response["ItemLookupResponse"]["Items"]["Item"].is_a? Array
			item_counts = @parsed_response["ItemLookupResponse"]["Items"]["Item"].size

			(0...item_counts).each do |i|
				# The following is the logic to select an item to scrape.
				# The following logic does not disallow ebook
				#if @parsed_response["ItemLookupResponse"]["Items"]["Item"][i].has_key?("LargeImage") && @parsed_response["ItemLookupResponse"]["Items"]["Item"][i]["ItemAttributes"]["Publisher"] != nil
				
				# Force Book, not Ebook
				if @parsed_response["ItemLookupResponse"]["Items"]["Item"][i]["ItemAttributes"]["ProductGroup"] == "Book"

				# Disallow ebook whatsoever
				#if @parsed_response["ItemLookupResponse"]["Items"]["Item"][i]["ItemAttributes"]["ProductGroup"] != "eBooks" && @parsed_response["ItemLookupResponse"]["Items"]["Item"][i]["ItemAttributes"]["Publisher"] != nil
					@item_index = i
				else
					next
				end
			end
		end
end

def categories
	# multiple items
	if @parsed_response["ItemLookupResponse"]["Items"]["Item"].is_a? Array
		which_item
		@browsenodes_count = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["BrowseNodes"]["BrowseNode"].size
		@browsenodes = []
		
		#ap @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["BrowseNodes"]

		(0...@browsenodes_count).each do |i|
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["BrowseNodes"]["BrowseNode"].is_a? Array
				category = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["BrowseNodes"]["BrowseNode"][i]
			else
				category = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["BrowseNodes"]["BrowseNode"]
			end

			if category.has_key?("Ancestors")
				@browsenodes << category["Name"]
				@browsenodes << category["Ancestors"]["BrowseNode"]["Name"]
			else
			 	@browsenodes << category["Name"]
			end
			return @browsenodes.uniq.reverse.join(", ")
				
		end

	# single item
	else
		#ap @parsed_response["ItemLookupResponse"]["Items"]["Item"]["BrowseNodes"]["BrowseNode"][0].flatten
		@browsenodes_count = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["BrowseNodes"]["BrowseNode"].size
		@browsenodes = []

		
		(0...@browsenodes_count).each do |i|
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"]["BrowseNodes"]["BrowseNode"].is_a? Array
				category = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["BrowseNodes"]["BrowseNode"][i]
			else
				category = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["BrowseNodes"]["BrowseNode"]
			end

			if category.has_key?("Ancestors")
				@browsenodes << category["Name"]
				@browsenodes << category["Ancestors"]["BrowseNode"]["Name"]
			else
			 	@browsenodes << category["Name"]
			end

			return @browsenodes.uniq.reverse.join(", ")
				
		end
	end
end

Dotenv.load

# Configuration
@request = Vacuum.new('US')
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
isbns.each_with_index do |isbn, index|
	Retriable.retriable tries: 5, base_interval: 2 do
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
	

	@parsed_response = @response.to_h	

	starting_time_per_item = Time.now.to_f

	# If error
	if @parsed_response["ItemLookupResponse"]["Items"]["Request"].has_key?("Errors")
		@error_message = @parsed_response["ItemLookupResponse"]["Items"]["Request"]["Errors"]["Error"]["Message"]
		ap @error_message
		
		# Write to CSV
		CSV.open("data/amazon_results.csv", "a") do |csv|
			csv << [ isbn, @error_message ]
		end

	# No error
	else

		# Debugging
		#ap @parsed_response["ItemLookupResponse"]["Items"]["Item"]
		#abort
		# End debugging

		# Parse

		# Case 1. If MULTIPLE book results found with the given isbn
		# Need to determine which one to scrape
		if @parsed_response["ItemLookupResponse"]["Items"]["Item"].is_a? Array
			# Number of items shown as search results
			# Case a. Single book with two duplicate pages, one of which is not maintained
			# Case b. Two books, hard/softcover and ebook.
			
			which_item

		end


		if @parsed_response["ItemLookupResponse"]["Items"]["Item"].is_a? Array
			# EAN
			@ean = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("EAN", "N/A")
			# Title
			@title = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("Title", "N/A")
			# Author
			# if multiple authors, join them
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Author"].is_a? Array
				@author = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Author"].join(', ')
			# Otherwise, print as is
			else
				@author = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("Author", "N/A")
			end
			
			# Creator
			@creator_and_role = []
			# creator == contributors, different from author
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].is_a? Hash

				# only one set	
				@creator_and_role = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].values.join(' - ')

			# multiple creators
			elsif @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].is_a? Array

				@parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Creator"].each do |hash|
					@creator_and_role << hash.values.join(' - ')
					
				end

			# No creators listed
			else 
				@creator_and_role = 'None'
			end

			# Company
			@company = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("Publisher", "N/A")
			# PubDate
			@pub_date = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("PublicationDate", "N/A")
			# Binding
			@binding = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("Binding", "N/A")
			# Number of Pages
			@number_of_pages = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].fetch("NumberOfPages", "N/A")
			# Book page url
			@book_page_url = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index].fetch("DetailPageURL", "N/A")
			# Cover image
			@cover_image_url = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index].fetch("LargeImage", {}).fetch("URL", "N/A")
			# Language
			# Most of the time, it's multiple
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"].has_key?("Languages")
				if @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"].is_a? Array
					@language = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"][0]["Name"]
				# Single language
				elsif @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"].is_a? Hash
					@language = @parsed_response["ItemLookupResponse"]["Items"]["Item"][@item_index]["ItemAttributes"]["Languages"]["Language"]["Name"]
				# Doesn't exist
				else
					@language = "N/A"
				end
			else
				@language = "N/A"
			end
			# Category
			@categories = categories

		
		#################	
		# Case 2. SINGLE book results with the given isbn
		else
			# EAN
			@ean = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("EAN") { "N/A" }
			# Title
			@title = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("Title") { "N/A" }
			# Author
			# if multiple authors, join them
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Author"].is_a? Array
				@author = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Author"].join(', ')
			# Otherwise, print as is
			else
				@author = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("Author", "N/A")
			end
			# Creator
			@creator_and_role = []
			# creator == contributors, different from author
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].is_a? Hash

				# only one set	
				@creator_and_role = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].values.join(' - ')

			# multiple creators
			elsif @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].is_a? Array
				
				@parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].each do |hash|
					@creator_and_role << hash.values.join(' - ')
				end

			# otherwise, no creators listed
			else
				@creator_and_role = 'None'
			end

			# Company
			@company = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("Publisher") { "N/A" }
			# PubDate
			@pub_date = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("PublicationDate", "N/A")
			# Binding
			@binding = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("Binding", "N/A")
			# Number of Pages
			@number_of_pages = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].fetch("NumberOfPages", "N/A")
			# Book page url
			@book_page_url = @parsed_response["ItemLookupResponse"]["Items"]["Item"].fetch("DetailPageURL", "N/A")
			# Cover image
			@cover_image_url = @parsed_response["ItemLookupResponse"]["Items"]["Item"].fetch("LargeImage", {}).fetch("URL", "N/A")
			# Language
			# Most of the time, it's multiple
			if @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"].has_key?("Languages")
				if @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"].is_a? Array
					@language = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"][0]["Name"]
				# Single language
				elsif @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"].is_a? Hash
					@language = @parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"]["Name"]
				# Doesn't exist
				else
					@language = "N/A"
				end
			else
				@language = "N/A"
			end

			@categories = categories

			@item_counts = 1

		end

		##################################################
		# Final process to make things neat
		@creator_and_role = @creator_and_role*", " if @creator_and_role.is_a? Array

		
		##################################################
		# Write the results to CSV
		CSV.open("data/amazon_results.csv", "a") do |csv|
			csv << [ @ean, @title, @company, @author, @creator_and_role, @pub_date, @binding, @number_of_pages, @language, @book_page_url, @cover_image_url, @categories ]
		end

	ending_time_per_item = Time.now.to_f
	elapsed_time_per_item = (ending_time_per_item - starting_time_per_item) * 1000
	remaining_items = @isbns_size - index - 1

	remaining_time = elapsed_time_per_item * remaining_items

	@query_count += 1
	print " ... OK \t #{@query_count} / #{@isbns_size} \t #{remaining_time.round(1)} sec remaining ... \t #{remaining_items} items remaining.\n"
	end

end # End File.readlines

puts "All done"
system('say -v Alex "Amazon is done. Come back to work again." ')