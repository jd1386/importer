require 'open-uri'
require 'ostruct'
require 'awesome_print'
require 'json'
require 'csv'
require 'colorize'
require 'dotenv'
require 'retriable'

Dotenv.load


# Load isbns
def load_isbns
	@isbns = []
	File.readlines("data/pl_search_isbn_source.txt").each do |line|
		@isbns <<	line.rstrip
	end	
	puts "ISBNs loaded!"
	sleep 1
end

def save_to_array(isbn, response, index)
	if response # Response returned successfully
		@container << [ isbn, response["title/_text"], response["title"], response["cover_image"], index ]
	else # No response returned
		@container << [ isbn, 'N/A', 'N/A', 'N/A', index ]
	end
end

def save_to_csv(isbn, title, link, cover_image)
	CSV.open('data/pl_search_isbn_results.csv', 'a') do |csv|

		if title.nil?
			puts "#{isbn} ... ERROR".red

			csv << [ isbn, "Error" ]
		else
			puts "#{isbn} ... OK".blue
			#puts response

			# title = response['title/_text']
			# link = response['title']
			# cover_image = response['cover_image']

			csv << [ isbn, title, link, cover_image ]
		end
	end
end

def query(isbn, index)
		begin
			response = JSON.parse(open("https://api.import.io/store/connector/1a990b0f-e448-4b13-b505-510b322dfb0f/_query?input=query:#{isbn}&&_apikey=#{ENV['IMPORTIO_KEY']}").read)
			# Force only first returned result since, otherwise, 
			# it'll scrape everything irrelevant
			response = response["results"][0] 
			save_to_array(isbn, response, index)
		rescue # No response
			save_to_array(isbn, nil, index)
		end
end


# Controller
@container = []

load_isbns


@isbns.each_with_index do |isbn, index|
	puts "Queried index #{index + 1}".yellow

	@threads = []
	@threads << Thread.new { query(isbn, index) }
end

Thread.list.each do |t|
	t.join if t != Thread.current
end

@container.sort_by! { |e| e[4] }
ap @container

#Save results to csv
@container.each do |c|
	save_to_csv(c[0], c[1], c[2], c[3])
end

puts "DONE!"