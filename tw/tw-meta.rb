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
require 'chronic'


def clean_meta_1(meta_1)
	# meta_1 is now an array

	# clean up
	meta_1 = meta_1.delete_if { |e| e == "" }.delete_if { |e| !e.include? "：" }

	meta_1.each {|e| e.split }.slice(1...4).join(" ").gsub(/\s+/, ' ')
	# ap meta_1
	# ap meta_1.size

	# pub_date_and_language = meta_1.last
	# ap @pub_date = pub_date_and_language.split("語言")[0].gsub("出版日期：", "")
	# ap @language = pub_date_and_language.split("語言")[1].gsub('：', '')

end

def clean_meta_2(meta_2)
	meta_2.gsub!("：", ": ")
end

def clean_authors(raw_authors)
	raw_authors.gsub('已追蹤作者：[ 修改 ] 確定 取消 ', '').gsub('    新功能介紹','').gsub('作者： ', '')
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
				@title_primary, 
				@title_secondary, 
				@authors,
				@description,
				@cover_image,
				@meta_1, 
				@meta_2,
				@pub_date,
				@language
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
	@title_secondary = page.search("div.mod.type02_p002.clearfix").search("h2").text.strip.gsub("\n", "")

	@authors = page.at("//div[@class='type02_p003 clearfix']/ul/li[1]").text.strip.gsub(/\s+/, ' ')
	@authors = clean_authors(@authors)

	@meta_1 = page.search("//div[@class='type02_p003 clearfix']//li").text.strip.split("\n")
	@meta_1 = clean_meta_1(@meta_1)

	@meta_2 = page.search("//div[@class='mod_b type02_m058 clearfix']/div[@class='bd']").text.strip.gsub(/\s+/, ' ')
	@meta_2 = clean_meta_2(@meta_2)

	@isbn = page.search("//div[@class='mod_b type02_m058 clearfix']/div[@class='bd']/ul[1]/li[1]").text.strip.match(/978\d{10}/)

	@description = page.search("//div[@class='bd']/div[@class='content']").text.strip.gsub(/\s+/, ' ')
	@cover_image = page.search("img.cover.M201106_0_getTakelook_P00a400020052_image_wrap")[0]['src']


	puts @current_page
	puts @isbn
	#puts @title_primary 
	#puts @title_secondary 
	#puts @authors
	#puts @meta_1
	#puts @meta_2
	#puts @description
	#puts @cover_image

	write_to_csv('success')

	puts "===================================="

end

