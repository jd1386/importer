
#first_page = "http://www.bookdepository.com/category/2560/English-Literature/?page=1&searchRefined=1&ieutf8=%E2%98%A0&searchAddedTerm=&submit=Go&price=&availability=&format=&searchSortBy=pubdate_high_low&searchLang=123"


# Write the results to the file
File.open('/Users/jungdolee/projects/importer/data/page-generate-results.txt', 'w') do |f|
	#f.puts first_page
	
	(1..50).each do |page|
		f.puts "http://neoluxor.cz/detske/?f:ord=4&f:dir=0&f:lt=1&b.pagenumber=#{page}&preserveFilter=1"
	end
end
puts "Done! The results saved to data/page-generate-results.txt"