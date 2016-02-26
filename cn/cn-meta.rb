<<-COMMENT


COMMENT

require 'mechanize'
require 'awesome_print'
require 'csv'
require 'colorize'


def save_to_csv(index, uri=nil, title=nil, hash=nil)
	if uri.nil?
		CSV.open("meta_results.csv", "a") do |csv|
			csv << ['ERROR']
		end
	else
		CSV.open("meta_results.csv", "a") do |csv|
			csv << [
				uri,
				title,
				hash["ISBN"],			# isbn
				hash["出版时间"],		# pub_date
				hash["出版社"],			# publisher
				hash["正文语种"]			# language
			]
		end
	end
end

def connect_and_parse(page, index)
	page = @agent.get(page)

	current_page = page.uri.to_s
	title = page.search("div#name/h1").text.strip.gsub(/\s+/, ' ')


	hash = {}
	page.search("ul#parameter2.p-parameter-list//li").each do |li|
		key = li.text.strip.split("：").first.strip
		value = li.text.strip.split("：").last.strip

		hash[key] = value
	end

	@container << [index, current_page, title, hash]

end

def handle_results(page, index)
	begin
		connect_and_parse(page, index)
	rescue Mechanize::ChunkedTerminationError => e
		#puts "ERROR OCCURRED: Mechanize::ChunkedTerminationError".red
		connect_and_parse(page, index)
	end
end

pages = []

File.readlines('meta_source.txt', encoding: 'UTF-8').each do |line|
	pages << line.rstrip
end

pages.each_slice(10).with_index do |batch, batch_index|

	batch.each_with_index do |page, item_index|
		global_index = batch_index + item_index / 100.00
		puts global_index.to_s.yellow

		@container = []
		@threads = []
		@threads << Thread.new {
			@agent = Mechanize.new
			@agent.user_agent_alias = 'Windows Edge'
			handle_results(page, global_index)
		}

	end

	# Join threads
		Thread.list.each do |t|
  		t.join if t != Thread.current
		end

	# Sort container by index value, otherwise it'll mess up order
	@container.sort_by! { |e| e[0] }

	#Save results to csv
	@container.each do |e|
		save_to_csv(e[0], e[1], e[2], e[3])
	end

	puts "===================================="

end


# # Sort container by index value, otherwise it'll mess up order
# @container.sort_by! { |e| e[0] }

# ap @container

# # Save results to csv
# @container.each do |e|
# 	save_to_csv(e[0], e[1], e[2], e[3])
# end

puts "Everything's done!"