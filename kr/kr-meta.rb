<<-COMMENT

Aladin:
	유아: CID=13789
	어린이: CID=1108
	청소년: CID=1137

COMMENT

require 'mechanize'
require 'awesome_print'
require 'csv'
require 'colorize'


def clean_meta_1(meta_1)
	splitted = meta_1.split(" | ")
	size = splitted.size

	if splitted.any?
		if splitted[size - 1].include? '원제'
			@original_title = splitted[size - 1].gsub('원제 ', '')
			@pub_date = splitted[size - 2]
			@publisher = splitted[size - 3]
			@authors = splitted[0..size-4].join(', ')
		else
			@original_title = ''
			@pub_date = splitted[size - 1]
			@publisher = splitted[size - 2]
			@authors = splitted[0..size-3].join(', ')
		end
	else
		puts "ERROR FOUND! - Meta 1".red
		return "error"
	end


	return @authors, @publisher, @pub_date, @original_title
end

def clean_meta_2(meta_2)
	splitted = meta_2.split(" | ")
	size = splitted.size

	if splitted.any?
		if size == 4
			@binding = ''
		elsif size == 5
			@binding = splitted[0]
		end
		@pages = splitted[size - 4]
		@dimension = splitted[size - 3]
		@weight = splitted[size - 2]
		@isbn = splitted[size - 1].gsub("ISBN : ", "")
	else
		puts "ERROR FOUND! - Meta 2".red
		return "error"
	end
end

def results_returned?
	true if clean_meta_1(@meta_1) != 'error' && clean_meta_2(@meta_2) != 'error'
end

def write_to_csv(results)
	if results == 'error'
		CSV.open("meta_results.csv", "a") do |csv|
			csv << ['ERROR']
		end
	else
		CSV.open("meta_results.csv", "a") do |csv|
			csv << [
				@current_page,
				@isbn,
				@title_and_subtitle,
				@authors,
				@publisher,
				@pub_date,
				@original_title,
				@cover_image,
				@series,
				@binding,
				@dimension,
				@weight
			]
		end
	end
end


pages = []
links = []

File.readlines('meta_source.txt', encoding: 'UTF-8').each do |line|
	pages << line.rstrip
end

pages.each_with_index do |page, index|
	puts "Page #{index + 1} ... "

	agent = Mechanize.new
	agent.user_agent_alias = 'Windows Edge'
	page = agent.get(page)
	page.encoding = "euc-kr"


	@current_page = page.uri.to_s
	title_subtitle_and_series = page.search("td.pwrap_bgtit").search("table[1]").text.strip
	@title_and_subtitle = title_subtitle_and_series.split(" l ")[0]
	@series = title_subtitle_and_series.split(" l ")[1]
	@meta_1 = page.search("td.pwrap_bgtit/table[2]").search("tr/td[1]").text.strip
	meta_1_cleaned = clean_meta_1(@meta_1)
	# meta_2 includes authors, publisher, and pub_date
	if page.search("div.p_goodstd03").first
		@meta_2 = page.search("div.p_goodstd03").first.text.strip
		meta_2_cleaned = clean_meta_2(@meta_2)
	else
		meta_2_cleaned = clean_meta_2("")
	end


	@cover_image = page.image_with(src: /cover/)


	puts @current_page, @title_and_subtitle, @series, @authors, @publisher, @pub_date, @original_title
	puts @binding, @dimension, @weight, @isbn
	puts @cover_image
	puts "===================================="

	if results_returned? == true
		write_to_csv('success')
	else
		write_to_csv('error')
	end

end

