<<-COMMENT

Aladin:
	어린이: CID=1108
	유아: CID=13789

COMMENT

require 'mechanize'
require 'awesome_print'

def clean_meta_1(meta_1)
	splitted = meta_1.split(" | ")
	size = splitted.size
	
	if splitted[size - 1].include? '원제'
		original_title = splitted[size - 1]
		pub_date = splitted[size - 2] 
		publisher = splitted[size - 3]
		authors = splitted[0..size-4].join(', ')
	else
		original_title = ''
		pub_date = splitted[size - 1] 
		publisher = splitted[size - 2]
		authors = splitted[0..size-3].join(', ')
	end
	

	return authors, publisher, pub_date, original_title
end

def clean_meta_2(meta_2)
	meta_2.split(" | ")
end

pages = []
links = []

File.readlines('meta_source.txt', encoding: 'UTF-8').each do |line|
	pages << line.rstrip
end

pages.each_with_index do |page, index|
	print "Page #{index + 1} ... "

	agent = Mechanize.new
	agent.user_agent_alias = 'Windows Edge'
	page = agent.get(page)
	page.encoding = "euc-kr"


	title_subtitle_and_series = page.search("td.pwrap_bgtit").search("table[1]")[0].text.strip
	title_and_subtitle = title_subtitle_and_series.split(" l ")[0]
	series = title_subtitle_and_series.split(" l ")[1]

	puts "#{title_and_subtitle} #{(series)}"

	meta_1 = page.search("td.pwrap_bgtit/table[2]").search("tr/td[1]").text.strip
	meta_1_cleaned = clean_meta_1(meta_1)
	ap meta_1_cleaned

	# meta_2 includes authors, publisher, and pub_date
	meta_2 = page.search("div.p_goodstd03").text.strip
	meta_2_cleaned = clean_meta_2(meta_2)
	puts "\t#{meta_2_cleaned}"

	#categories = page.search("div.p_categorize").text.strip
	#puts "\t#{categories}"

	
	

	#print "DONE\n"
end



# CSV.open("data/amazon_results.csv", "a") do |csv|
# 	csv << [  ]
# end
