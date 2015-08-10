
first_page = "http://www.bookdepository.com/category/2488/Fiction/?page=1&searchRefined=1&ieutf8=%E2%98%A0&searchAddedTerm=&submit=Go&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123"
#page_scheme = "http://www.bookdepository.com/category/2488/Fiction/best/seller?searchTerm=&addedTerm=&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123&searchTitle=&searchAuthor=&searchPublisher=&searchIsbn=&hasJacket=&seriesId=0&searchDeep=&page=#{page}#pagination"


# Write the results to the file
File.open('data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(8001..8200).each do |page|
		f.puts "http://www.bookdepository.com/category/2488/Fiction/best/seller?searchTerm=&addedTerm=&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123&searchTitle=&searchAuthor=&searchPublisher=&searchIsbn=&hasJacket=&seriesId=0&searchDeep=&page=#{page}#pagination"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"




