<<-COMMENT

Aladin:
	유아: CID=13789
	어린이: CID=1108
	청소년: CID=1137

COMMENT

# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page

	(1..620).each do |page|
		f.puts "http://www.aladin.co.kr/shop/wbrowse.aspx?BrowseTarget=List&ViewRowsCount=25&ViewType=Detail&PublishMonth=0&SortOrder=5&page=#{page}&Stockstatus=1&PublishDay=84&CID=13789&CustReviewRankStart=&CustReviewRankEnd=&CustReviewCountStart=&CustReviewCountEnd=&PriceFilterMin=&PriceFilterMax="
	end
end
puts "Done! The results saved to data/page-generate-results.txt"