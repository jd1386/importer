<<-COMMENT

Aladin:
	어린이: CID=1108
	유아: CID=13789

COMMENT

require 'mechanize'
require 'awesome_print'

recent_pages = []
links = []

File.readlines('recent_source.txt', encoding: 'UTF-8').each do |line|
	recent_pages << line.rstrip
end

recent_pages.each_with_index do |recent_page, index|
	print "Page #{index + 1} ... "

	agent = Mechanize.new
	page = agent.get(recent_page)
	page.encoding = "euc-kr"

	book_links = page.search("a.bo3")


	book_links.each do |link|
		links << link.attribute('href').to_s
	end

	print "DONE\n"
end



File.open('recent_results.txt', 'w') do |f| 
	links.each { |link| f.puts link }
end

ap links