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

def parse(page, index)
	hash = {}

	hash["index"] = index
	hash["current_page"] = page.uri.to_s
	hash["title_primary"] = page.search("div.mod.type02_p002.clearfix").search("h1").text.strip
	hash["title_secondary"] = page.search("div.mod.type02_p002.clearfix").search("h2").text.strip.gsub("\n", "")
	authors = page.at("//div[@class='type02_p003 clearfix']/ul/li[1]").text.strip.gsub(/\s+/, ' ')
	hash["authors"] = clean_authors(authors)
	meta_1 = page.search("//div[@class='type02_p003 clearfix']//li").text.strip.split("\n")
	hash["meta_1"] = clean_meta_1(meta_1)
	meta_2 = page.search("//div[@class='mod_b type02_m058 clearfix']/div[@class='bd']").text.strip.gsub(/\s+/, ' ')
	hash["meta_2"] = clean_meta_2(meta_2)
	hash["isbn"] = page.search("//div[@class='mod_b type02_m058 clearfix']/div[@class='bd']/ul[1]/li[1]").text.strip.match(/978\d{10}/)
	hash["description"] = page.search("//div[@class='bd']/div[@class='content']").text.strip.gsub(/\s+/, ' ')
	hash["cover_image"] = page.search("img.cover.M201106_0_getTakelook_P00a400020052_image_wrap")[0]['src']

	@big_con << hash
end


def clean_meta_1(meta_1)
	# clean up
	meta_1 = meta_1.delete_if { |e| e == "" }.delete_if { |e| !e.include? "：" }
	meta_1.each {|e| e.split }.slice(1...4).join(" ").gsub(/\s+/, ' ')
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



pages = []
links = []

File.readlines('meta_source.txt', encoding: 'UTF-8').each do |line|
	pages << line.rstrip
end

pages.each_slice(20).with_index do |batch, batch_index|
	puts "Batch #{batch_index + 1} ... "

	batch.each_with_index do |page, item_index|
		global_index = batch_index + item_index / 100.0

		@big_con = []
		@threads = []
		@threads << Thread.new {
			@agent = Mechanize.new
			@agent.user_agent_alias = 'Windows Edge'
			parse(@agent.get(page), global_index)
		}
	end

end

# Join threads
Thread.list.each do |t|
	t.join if t != Thread.current
end

# # Sort container by index value, otherwise it'll mess up order
@big_con.sort_by! { |e| e["index"] }

@big_con.each do |e|

	CSV.open("meta_results.csv", "a") do |csv|
		csv << [ 
			e["current_page"],
			e["isbn"],
			e["title_primary"],
			e["title_secondary"],
			e["authors"],
			e["description"],
			e["cover_image"],
			e["meta_1"],
			e["meta_2"],
			e["pub_date"],
			e["language"]
			# @current_page,
			# @isbn,
			# @title_primary,
			# @title_secondary,
			# @authors,
			# @description,
			# @cover_image,
			# @meta_1,
			# @meta_2,
			# @pub_date,
			# @language
		]
		
	end
	
end