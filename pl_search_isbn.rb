require 'open-uri'
require 'ostruct'
require 'awesome_print'
require 'json'
require 'csv'
require 'colorize'
require 'dotenv'

Dotenv.load


# Load isbns
def load_isbns
	@isbns = []
	File.readlines("data/pl_search_isbn_source.txt").each do |line|
		@isbns <<	line.rstrip
	end	
	puts "ISBNs loaded!"
	sleep 1
	ap @isbns
end

def save_response_to_file(isbn, response)
	CSV.open('data/pl_search_isbn_results.csv', 'a') do |csv|
		title = response['title/_text']
		link = response['title']
		cover_image = response['cover_image']

		csv << [ isbn, title, link, cover_image ]
	end
end

def query(isbn)
	begin
		response = JSON.parse(open("https://api.import.io/store/connector/1a990b0f-e448-4b13-b505-510b322dfb0f/_query?input=query:#{isbn}&&_apikey=#{ENV['IMPORTIO_KEY']}").read)
		response = response["results"][0]
		puts response
		save_response_to_file(isbn, response)
	rescue OpenURI::HTTPError => error
		response = error.io
	end
end


# Controller

load_isbns

@isbns.each_with_index do |isbn, index|
	puts "INDEX #{index}".yellow
	query(isbn)
end



