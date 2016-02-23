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
	page.encoding = "utf-8"


	@current_page = page.uri.to_s
	@title_primary = page.search("div.mod.type02_p002.clearfix").search("h1").text.strip
	@title_secondary = page.search("div.mod.type02_p002.clearfix").search("h2").text.strip
	@authors = page.search("//div[@class='type02_p003 clearfix']/ul/li[1]/a[1]").text.strip
	@meta_1 = page.search("//div[@class='type02_p003 clearfix']/ul").text.strip.gsub('已追蹤作者：[ 修改 ]



確定
取消
    ', '')
	@description = page.search("//div[@class='bd']/div[@class='content']").text.strip
	@meta_2 = page.search("//div[@class='mod_b type02_m058 clearfix']/div[@class='bd']").text.strip
	

	@cover_image = page.search("img.cover.M201106_0_getTakelook_P00a400020052_image_wrap")[0]['src']


	puts @current_page, @title_primary, @title_secondary, @authors, @meta_1, @meta_2, @description
	puts @cover_image
	puts "===================================="

end

