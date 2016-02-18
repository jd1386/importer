<<-COMMENT

On Feb. 18, 2016, import.io got really slow and was not reliable to fetch info from.
This program fetches all the recent titles' isbns from Kinokuniya site.
Since we'll be using Amazon JP for book metadata, we only need isbns.

COMMENT

require 'mechanize'
require 'awesome_print'

recent_pages = []
isbns = []

File.readlines('recent_source.txt', encoding: 'UTF-8').each do |line|
	recent_pages << line.rstrip
end

recent_pages.each_with_index do |recent_page, index|
	print "Page #{index + 1} ... "

	agent = Mechanize.new
	page = agent.get(recent_page)
	book_links = page.search("h3.heightLine-2 a")

	book_links.each do |link|
		url = link.attribute('href').to_s
		isbns << url.match('978\d{1,10}').to_s
	end

	print "DONE\n"
end



File.open('recent_results.txt', 'w') do |f| 
	isbns.each { |isbn| f.puts isbn }
end

ap isbns