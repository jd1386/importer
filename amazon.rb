require 'Vacuum'
require 'dotenv'
require 'awesome_print'
require 'csv'
require 'json'

Dotenv.load

# Configuration
request = Vacuum.new('ES')
request.configure(
	aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
	aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
	associate_tag: ENV['AWS_ASSOCIATE_TAG']
)


# Load isbns to look up
isbns = []

File.readlines('data/amazon_isbns.txt').each do |line|
	isbns << line.rstrip
end


# Query each isbn
isbns.each do |isbn|
	response = request.item_lookup(
	  query: {
	    'IdType' => 'ISBN',
	    'ItemId' => isbn,
	    'SearchIndex' => 'Books',
	    'ResponseGroup' => 'Large',
	    'MerchantId' => 'Amazon'
	  }
	)

	

	parsed_response = response.to_h


	# If no results found or error message, print it
	if parsed_response["ItemLookupResponse"]["Items"]["Request"]["Errors"]
		@error_message = parsed_response["ItemLookupResponse"]["Items"]["Request"]["Errors"]["Error"]["Message"]
		ap @error_message

		# Write to CSV
		CSV.open("data/amazon_results.csv", "a") do |csv|
			csv << [ isbn, @error_message ]
		end

	else
	# Parsing
	@ean = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["EAN"]
	@title = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
	@author = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Author"]
	
	@creator_and_role = []
	# creator == contributors, different from author
	if parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].is_a? Hash

		# only one set	
		@creator_and_role = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].values.join(' - ')

	# multiple creators
	elsif parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].is_a? Array
		parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Creator"].each do |hash|
			@creator_and_role << hash.values.join(' - ')
			@creator_and_role.join(', ')
		end
	
	
	end

	
	@company = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Publisher"]
	@pub_date = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["PublicationDate"]
	@binding = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Binding"]
	@number_of_pages = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["NumberOfPages"]
	@book_page_url = parsed_response["ItemLookupResponse"]["Items"]["Item"]["DetailPageURL"]
	@cover_image_url = parsed_response["ItemLookupResponse"]["Items"]["Item"]["MediumImage"]["URL"]
	@number_of_pages = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["NumberOfPages"]
	@language = parsed_response["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Languages"]["Language"][0]["Name"]

	
	puts parsed_response["ItemLookupResponse"]["Items"].to_yaml



	# Write the results to CSV
	CSV.open("data/amazon_results.csv", "a") do |csv|
		csv << [ @ean, @title, @author, @creator_and_role, @company, @pub_date, @binding, @number_of_pages, @language, @book_page_url, @cover_image_url ]
	end

end

end

puts "Done"

